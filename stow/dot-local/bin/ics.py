#!/usr/bin/env python3
import re
import sys
from datetime import datetime, timedelta

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} <input.ics> <output.txt>")
    sys.exit(1)

ICS_FILE = sys.argv[1]
OUTPUT_FILE = sys.argv[2]

DAY_MAP = {"MO": 0, "TU": 1, "WE": 2, "TH": 3, "FR": 4, "SA": 5, "SU": 6}
WEEKDAY_NAME = {0: "Mon", 1: "Tue", 2: "Wed", 3: "Thu", 4: "Fri", 5: "Sat", 6: "Sun"}

def parse_dt(dt_str):
    dt_str = dt_str.replace("Z", "").strip()
    if 'T' not in dt_str:
        return None
    parts = dt_str.split('T')
    date_part = parts[0]
    time_part = parts[1] if len(parts) > 1 else "000000"
    year = int(date_part[0:4])
    month = int(date_part[4:6])
    day = int(date_part[6:8])
    hour = int(time_part[0:2])
    minute = int(time_part[2:4])
    second = int(time_part[4:6]) if len(time_part) >= 6 else 0
    return datetime(year, month, day, hour, minute, second)

def parse_rrulestr(rrulestr):
    params = {}
    for part in rrulestr.split(';'):
        if '=' in part:
            key, val = part.split('=', 1)
            params[key] = val
    return params

def expand_recurrences(event, start_of_week, end_of_week):
    expanded = []
    dtstart = event.get('dtstart')
    dtend = event.get('dtend')
    rrule_str = event.get('rrule')
    duration = (dtend - dtstart) if dtstart and dtend else timedelta(hours=1)

    if not rrule_str or not dtstart:
        expanded.append(event)
        return expanded

    params = parse_rrulestr(rrule_str)
    freq = params.get('FREQ', 'WEEKLY')
    until_str = params.get('UNTIL')
    byday = params.get('BYDAY', '')
    interval = int(params.get('INTERVAL', 1))

    until = None
    if until_str:
        until = parse_dt(until_str)

    byday_days = [DAY_MAP[d.strip()] for d in byday.split(',') if d.strip() in DAY_MAP] if byday else None

    current = dtstart
    max_iterations = 500
    iterations = 0
    end_dt = datetime.combine(end_of_week, datetime.max.time())

    while iterations < max_iterations:
        iterations += 1
        if until and current > until:
            break
        if current > end_dt + timedelta(days=1):
            break

        weekday = current.weekday()
        include = True

        if byday_days is not None:
            include = weekday in byday_days

        if include and start_of_week <= current.date() <= end_of_week:
            new_event = event.copy()
            new_event['dtstart'] = current
            new_event['dtend'] = current + duration
            expanded.append(new_event)

        if freq == 'DAILY':
            current += timedelta(days=interval)
        elif freq == 'WEEKLY':
            current += timedelta(days=1)
            if weekday == 6:
                current += timedelta(days=(interval - 1) * 7)
        else:
            current += timedelta(days=7 * interval)

    return expanded

with open(ICS_FILE, "r") as f:
    content = f.read()

events = []
current_event = {}
in_event = False

for line in content.split('\n'):
    line = line.strip()
    if line == "BEGIN:VEVENT":
        in_event = True
        current_event = {}
    elif line == "END:VEVENT":
        in_event = False
        if 'summary' in current_event and 'dtstart' in current_event:
            events.append(current_event)
    elif in_event:
        if line.startswith("DTSTART"):
            val = line.split(':', 1)[1] if ':' in line else line.split("DTSTART")[1].lstrip(":")
            current_event['dtstart'] = parse_dt(val)
        elif line.startswith("DTEND"):
            val = line.split(':', 1)[1] if ':' in line else line.split("DTEND")[1].lstrip(":")
            current_event['dtend'] = parse_dt(val)
        elif line.startswith("SUMMARY:"):
            current_event['summary'] = line[8:]
        elif line.startswith("RRULE:"):
            current_event['rrule'] = line[6:]

today = datetime.now().date()
days_until_monday = today.weekday()
start_of_week = today + timedelta(days=(7 - days_until_monday) if days_until_monday > 0 else 0)
end_of_week = start_of_week + timedelta(days=4)

all_week_events = []
for event in events:
    if 'rrule' in event:
        expanded = expand_recurrences(event, start_of_week, end_of_week)
        all_week_events.extend(expanded)
    else:
        event_date = event['dtstart'].date() if event['dtstart'] else None
        if event_date and start_of_week <= event_date <= end_of_week:
            all_week_events.append(event)

all_week_events.sort(key=lambda e: e['dtstart'])

DAY_HEADERS = {0: "Monday", 1: "Tuesday", 2: "Wednesday", 3: "Thursday",
               4: "Friday", 5: "Saturday", 6: "Sunday"}

with open(OUTPUT_FILE, "w") as f:
    # f.write(f"* Weekly Events ({start_of_week.strftime('%b %d')} - {end_of_week.strftime('%b %d, %Y')})\n\n")

    if not all_week_events:
        f.write("No events this week.\n")
    else:
        current_day = -1
        for event in all_week_events:
            dtstart = event['dtstart']
            dtend = event['dtend']
            weekday = dtstart.weekday()

            if weekday != current_day:
                if current_day != -1:
                    f.write("\n")
                f.write(f"** {DAY_HEADERS[weekday]}\n\n")
                current_day = weekday

            start_str = f"<{dtstart.strftime('%Y-%m-%d %a %H:%M')}--{dtend.strftime('%H:%M')}>"
            f.write(f"*** TODO {event['summary']}\n")
            f.write(f"SCHEDULED: {start_str}\n")

print(f"Written {len(all_week_events)} events to {OUTPUT_FILE}")

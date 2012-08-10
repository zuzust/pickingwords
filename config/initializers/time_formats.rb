Time::DATE_FORMATS[:last_edited_short] = ->(time) { time.getutc.today? ? "today" : time.strftime("%d %b %y") } 
Time::DATE_FORMATS[:last_edited_long]  = ->(time) { time.strftime("%d %b %y - %H:%M") } 

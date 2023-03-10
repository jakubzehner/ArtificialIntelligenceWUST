module simple_time

import regex

pub struct SimpleTime {
	time u16
}

pub fn (time SimpleTime) str() string {
	hour := time.time / 60
	minute := time.time % 60
	return '${hour:02}:${minute:02}:00'
}

pub fn from(time_string string) SimpleTime {
	mut re := regex.regex_opt(':') or { return SimpleTime{0}}
	splitted_time := re.split(time_string)

	hour := splitted_time[0].u16()
	minute := splitted_time[1].u16()
	return SimpleTime{hour * 60 + minute}
}


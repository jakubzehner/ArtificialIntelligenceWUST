module simple_time

pub struct SimpleTime {
	time u16
}

pub fn (time SimpleTime) str() string {
	h := time.time / 60
	m := time.time % 60

	return '${h:02}:${m:02}:00'
}

pub fn (time SimpleTime) short_str() string {
	return '${time.time}'
}

pub fn from(time_str string) SimpleTime {
	splitted_str := time_str.split(':')
	h := splitted_str[0].u16()
	m := splitted_str[1].u16()

	assert 0 <= h && h < 24, 'hour must be greater than or equal to 0 and less than 60'
	assert 0 <= m && m < 60, 'minutes must be greater than or equal to 0 and less than 60'

	return SimpleTime{h * 60 + m}
}

pub fn (t1 SimpleTime) + (t2 SimpleTime) SimpleTime {
	return SimpleTime{t1.time + t2.time}
}

pub fn (t1 SimpleTime) - (t2 SimpleTime) SimpleTime {
	return SimpleTime{t1.time - t2.time}
}

pub fn (t1 SimpleTime) < (t2 SimpleTime) bool {
	return t1.time < t2.time
}

pub fn (t1 SimpleTime) == (t2 SimpleTime) bool {
	return t1.time == t2.time
}

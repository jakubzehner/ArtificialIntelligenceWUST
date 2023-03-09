// Jakub Zehner 2023
import regex

struct Coordinates {
	latitude  f64
	longitude f64
}

fn (cord Coordinates) str() string {
	return 'lat: ${cord.latitude} lon: ${cord.longitude}'
}

fn coordinates_from(lat string, lon string) Coordinates {
	return Coordinates{lat.f64(), lon.f64()}
}

struct SimpleTime {
	hour   u8
	minute u8
}

fn (time SimpleTime) str() string {
	return '${time.hour:02}:${time.minute:02}:00'
}

fn simple_time_from(time_string string) SimpleTime {
	mut re := regex.regex_opt(':') or { return SimpleTime{u8(0), u8(0)}}
	splitted_time := re.split(time_string)
	return SimpleTime{splitted_time[0].u8(), splitted_time[1].u8()}
}

struct Link {
	id         int
	line       string
	start_time SimpleTime
	end_time   SimpleTime
	start_stop string
	end_stop   string
	start_cord Coordinates
	end_cord   Coordinates
}

use chrono::{DateTime, Datelike, Local, Weekday};
use hijri_date::HijriDate;
use std::{
  collections::HashMap,
  env, fs,
  path::{Path, PathBuf},
};

enum Calendars {
  Gregorian,
  Hijri,
  Jalali,
  // Hebrew,  // TODO
}

struct JalaliDate {
  year: i32,
  month: i32,
  day: i32,
  wday: Weekday,
}

impl JalaliDate {
  fn from_gregorian_date(date: DateTime<Local>) -> Self {
    let mut year = date.year();
    let month = date.month() as i32;
    let day = date.day() as i32;

    let g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    let mut jyear = if year > 1600 {
      year -= 1600;
      979
    } else {
      year -= 621;
      0
    };
    let gy2 = if month > 2 { year + 1 } else { year };

    let mut days = (365 * year) + ((gy2 + 3) / 4) - ((gy2 + 99) / 100) + ((gy2 + 399) / 400) - 80
      + day
      + g_d_m[(month - 1) as usize];
    jyear += 33 * (days / 12053);
    days %= 12053;
    jyear += 4 * (days / 1461);
    days %= 1461;
    if days > 365 {
      jyear += (days - 1) / 365;
      days = (days - 1) % 365;
    }

    let jm = if days < 186 {
      1 + (days / 31)
    } else {
      7 + ((days - 186) / 30)
    };
    let jd = 1
      + (if days < 186 {
        days % 31
      } else {
        (days - 186) % 30
      });

    JalaliDate {
      year: jyear,
      month: jm,
      day: jd,
      wday: date.weekday(),
    }
  }

  fn to_string(&self, text: &str) -> String {
    text
      .replace("yyyy", self.year.to_string().as_str())
      .replace(
        "MMM",
        match self.month {
          1 => "فروردین",
          2 => "اردیبهشت",
          3 => "خرداد",
          4 => "تیر",
          5 => "مرداد",
          6 => "شهریور",
          7 => "مهر",
          8 => "آبان",
          9 => "آذر",
          10 => "دی",
          11 => "بهمن",
          12 => "اسفند",
          _ => panic!("invalid month value of {}", self.month),
        },
      )
      .replace("MM", &format!("{:02}", self.month))
      .replace("dd", &format!("{:02}", self.day))
      .replace(
        "E",
        match self.wday {
          Weekday::Sat => "شنبه",
          Weekday::Sun => "یک‌شنبه",
          Weekday::Mon => "دوشنبه",
          Weekday::Tue => "سه‌شنبه",
          Weekday::Wed => "چهارشنبه",
          Weekday::Thu => "پنج‌شنبه",
          Weekday::Fri => "جمعه",
        },
      )
  }
}

pub struct Date {
  now: DateTime<Local>,
  hijri_date: HijriDate,
  jalali_date: JalaliDate,
  calendar: Calendars,
  file_path: PathBuf,
}

impl Date {
  pub fn new() -> Self {
    let path =
      Path::new(Path::new(&env::current_exe().unwrap()).parent().unwrap()).join(".calendar");
    let current_cal = match fs::read_to_string(&path) {
      Ok(s) => s,
      Err(_) => {
        fs::write(&path, "gregorian").expect("Unable to write calendar file");
        "gregorian".to_owned()
      }
    };

    // TODO string to enum ?
    let cal = match current_cal.as_str() {
      "gregorian" => Calendars::Gregorian,
      "hijri" => Calendars::Hijri,
      "jalali" => Calendars::Jalali,
      _ => Calendars::Gregorian,
    };

    let now = Local::now();

    let hijri_date = HijriDate::from_gr(
      now.year() as usize,
      now.month() as usize,
      now.day() as usize,
    )
    .unwrap();

    let jalali_date = JalaliDate::from_gregorian_date(now);

    Date {
      now,
      hijri_date,
      jalali_date,
      calendar: cal,
      file_path: path,
    }
  }

  fn replace(txt: String, map: HashMap<&str, &str>) -> String {
    let mut s = String::from(txt);
    for (d, ad) in &map {
      s = s.replace(d, ad);
    }
    s
  }

  fn arabize(txt: String) -> String {
    let a_digits = HashMap::from([
      ("1", "١"),
      ("2", "٢"),
      ("3", "٣"),
      ("4", "٤"),
      ("5", "٥"),
      ("6", "٦"),
      ("7", "٧"),
      ("8", "٨"),
      ("9", "٩"),
      ("0", "٠"),
    ]);

    Date::replace(txt, a_digits)
  }

  fn persianize(txt: String) -> String {
    let a_digits = HashMap::from([
      ("1", "۱"),
      ("2", "۲"),
      ("3", "۳"),
      ("4", "۴"),
      ("5", "۵"),
      ("6", "۶"),
      ("7", "۷"),
      ("8", "۸"),
      ("9", "۹"),
      ("0", "۰"),
    ]);

    Date::replace(txt, a_digits)
  }

  pub fn time(&self) -> String {
    self.now.format("%H:%M").to_string()
  }

  fn g_date_long(&self) -> String {
    self.now.format("%d/%m/%Y - %A, %d %B %Y").to_string()
  }

  pub fn g_date_short(&self) -> String {
    self.now.format("%d/%m/%Y").to_string()
  }

  pub fn g_date_shorty(&self) -> String {
    self.now.format("%d/%m/%y").to_string()
  }

  fn h_date_long(&self) -> String {
    Date::arabize(self.hijri_date.format("%Y/%m/%d - %D، %d %M %Yهـ.ق."))
  }

  pub fn h_date_short(&self) -> String {
    self.hijri_date.format("%d/%m/%Y").to_string()
  }

  fn j_date_long(&self) -> String {
    Date::persianize(self.jalali_date.to_string("yyyy/MM/ddهـ.ش. - E، dd MMM "))
  }

  pub fn long_date(&self) -> String {
    match self.calendar {
      Calendars::Gregorian => self.g_date_long(),
      Calendars::Hijri => self.h_date_long(),
      Calendars::Jalali => self.j_date_long(),
    }
  }

  pub fn next_calendar(&self) {
    match self.calendar {
      Calendars::Gregorian => {
        fs::write(&self.file_path, "hijri").expect("Unable to write calendar file")
      }
      Calendars::Hijri => {
        fs::write(&self.file_path, "jalali").expect("Unable to write calendar file")
      }
      Calendars::Jalali => {
        fs::write(&self.file_path, "hebrew").expect("Unable to write calendar file")
      }
    }
  }
}

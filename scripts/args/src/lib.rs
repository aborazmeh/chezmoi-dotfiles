use clap::{arg, Parser, ValueEnum};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
  /// What frontend to run the program in
  #[arg(short, long, value_enum)]
  frontend: Frontend,

  /// Next calendar
  #[arg(short, long)]
  calendar: bool,
}

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord, ValueEnum, Debug)]
pub enum Frontend {
  ///
  I3blocks,
  ///
  Waybar,
}


#[derive(Debug)]
pub struct Args {
  pub frontend: Frontend,
  pub calendar: bool,
}

pub fn argparse() -> Args {
  let cli = Cli::parse();
  Args {
    frontend: cli.frontend,
    calendar: cli.calendar,
  }
}

pub fn add(left: usize, right: usize) -> usize {
  left + right
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn it_works() {
    let result = add(2, 2);
    assert_eq!(result, 4);
  }
}

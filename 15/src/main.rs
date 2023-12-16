use std::error::Error;
use std::fs;

fn read_input(path: &str) -> Result<String, Box<dyn Error>> {
    let input = fs::read_to_string(path)?;
    match input.strip_suffix("\n") {
        Some(s) => Ok(s.to_string()),
        None => Ok(input),
    }
}

fn compute_hash_for_part(part: &str) -> u32 {
    part.chars().fold(0, |acc, c| ((acc + c as u32) * 17) % 256)
}

fn main() {
    let input = read_input("input.txt").unwrap();
    let sum: u32 = input.split(",").map(compute_hash_for_part).sum();
    println!("The result is {:?}", sum);
}

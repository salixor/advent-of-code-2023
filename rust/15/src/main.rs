use regex::Regex;
use std::collections::hash_map::Entry;
use std::collections::HashMap;
use std::error::Error;
use std::fs;

type Boxes = HashMap<usize, Vec<Lens>>;

enum Operations {
    RemoveLens,
    InsertOrUpdateLens,
}

struct Lens {
    label: String,
    focal_length: Option<usize>,
}

struct LensWithOperation {
    lens: Lens,
    destined_box: usize,
    operation: Operations,
}

fn read_input(path: &str) -> Result<String, Box<dyn Error>> {
    let input = fs::read_to_string(path)?;
    match input.strip_suffix("\n") {
        Some(s) => Ok(s.to_string()),
        None => Ok(input),
    }
}

fn compute_hash_for_part(part: &str) -> usize {
    part.chars()
        .fold(0, |acc, c| ((acc + c as usize) * 17) % 256)
}

fn insert_or_remove_lens_from_box(
    boxes: &mut Boxes,
    box_index: usize,
    lens: Lens,
    insert_lens: bool,
) -> () {
    match boxes.entry(box_index) {
        Entry::Vacant(entry) => {
            entry.insert(if insert_lens { vec![lens] } else { vec![] });
        }
        Entry::Occupied(entry) => {
            let lenses = entry.into_mut();
            if let Some(position) = lenses.iter().position(|l| l.label == lens.label) {
                if insert_lens {
                    lenses[position] = lens;
                } else {
                    lenses.remove(position);
                }
            } else if insert_lens {
                lenses.push(lens);
            }
        }
    }
}

fn remove_lens_from_box(boxes: &mut Boxes, box_index: usize, lens: Lens) -> () {
    insert_or_remove_lens_from_box(boxes, box_index, lens, false)
}

fn insert_lens_into_box(boxes: &mut Boxes, box_index: usize, lens: Lens) -> () {
    insert_or_remove_lens_from_box(boxes, box_index, lens, true)
}

fn convert_string_to_lens(item: &str) -> LensWithOperation {
    let re = Regex::new(r"([a-z]+)(-|=)([0-9]*)").unwrap();
    let Some(caps) = re.captures(item) else {
        panic!("There was an issue with the input data!")
    };
    let label = caps[1].to_string();
    LensWithOperation {
        destined_box: compute_hash_for_part(&label),
        operation: match &caps[2] {
            "-" => Operations::RemoveLens,
            "=" => Operations::InsertOrUpdateLens,
            _ => panic!("There was an issue with the input data!"),
        },
        lens: Lens {
            label,
            focal_length: match &caps[3] {
                "" => None,
                _ => Some(caps[3].parse::<usize>().unwrap()),
            },
        },
    }
}

fn get_focusing_power(box_index: &usize, lens_slot: &usize, lens: &Lens) -> usize {
    (1 + box_index) * lens_slot * lens.focal_length.unwrap()
}

fn main() {
    let input = read_input("input.txt").unwrap();

    let sum_part1: usize = input.split(",").map(compute_hash_for_part).sum();
    println!("The result for part 1 is {:?}", sum_part1);

    let mut boxes: Boxes = HashMap::new();
    for lens_with_operation in input.split(",").map(convert_string_to_lens) {
        match lens_with_operation.operation {
            Operations::InsertOrUpdateLens => insert_lens_into_box(
                &mut boxes,
                lens_with_operation.destined_box,
                lens_with_operation.lens,
            ),
            Operations::RemoveLens => remove_lens_from_box(
                &mut boxes,
                lens_with_operation.destined_box,
                lens_with_operation.lens,
            ),
        }
    }
    let sum_part2: usize = boxes
        .iter()
        .map(|(box_index, lenses)| {
            lenses
                .iter()
                .enumerate()
                .map(|(lens_slot, lens)| get_focusing_power(&box_index, &(lens_slot + 1), &lens))
                .sum::<usize>()
        })
        .sum();
    println!("The result for part 2 is {:?}", sum_part2);
}

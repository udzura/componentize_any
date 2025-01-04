use std::hash::{DefaultHasher, Hash, Hasher};

// big_data.bin is a random binary file genereated by following command:
// dd if=/dev/urandom of=big_data.bin bs=1M count=1
const BIG_DATA: &'static [u8] = include_bytes!("big_data.bin");

#[no_mangle]
pub fn add(left: i32, right: i32) -> i32 {
    left + right +
        hash(BIG_DATA)
}

fn hash(data: &[u8]) -> i32 {
    let mut hasher = DefaultHasher::new();
    data.hash(&mut hasher);
    (hasher.finish() % (1 << 31)) as i32
}
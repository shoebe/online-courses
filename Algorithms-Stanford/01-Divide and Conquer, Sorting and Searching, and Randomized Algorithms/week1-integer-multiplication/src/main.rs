use num::BigUint;
fn main() {
    let x = "3141592653589793238462643383279502884197169399375105820974944592".parse::<BigUint>().unwrap();
    let y = "2718281828459045235360287471352662497757247093699959574966967627".parse::<BigUint>().unwrap();
    let result = integer_multiplication::karatsuba_multiplication(&x, &y, 64);
    println!("{}", result);
}

use num::{BigUint, FromPrimitive};

// Karatsuba Algorithm
// x*y = ab*10^n + (ad+bc)*10^(n/2) + bd
// where x = a*10^(n/2) + b and y = c*10^(n/2) + d
// and (ad+bc) is (a+b)(c+d) - ab - bd

// must go down to pairs of numbers, per the assignment guideline
// n represents the max number of digits either x or y has, and must be a power of 2
pub fn karatsuba_multiplication(x: &BigUint, y: &BigUint, n:u32) -> BigUint {
    if n <= 2 {
        return x*y
    }
    let ten = BigUint::from_u8(10).unwrap();
 
    let a = x / ten.pow(n/2);
    let b = x % ten.pow(n/2);
    let c = y / ten.pow(n/2);
    let d = y % ten.pow(n/2);
    
    let ac = karatsuba_multiplication(&a,&c,n/2);
    let bd = karatsuba_multiplication(&b,&d,n/2);
    println!("a: {}, b: {}", a, b);
    let ad_bc = karatsuba_multiplication(&(&a+&b), &(&c+&d), n/2) - &ac - &bd;

    ac*ten.pow(n) + ad_bc*ten.pow(n/2) + bd
}

#[cfg(test)]
mod tests {
    use num::{BigUint, FromPrimitive};
    use super::*;
    use rand::random;
    #[test]
    fn thousand_squared() {
        let x = BigUint::from_u32(1000).unwrap();
        let result = karatsuba_multiplication(&x, &x, 4);
        assert_eq!(BigUint::from_u32(1000000).unwrap(), result);
    }

    #[test]
    fn random_numbers() {
        for _i in 0..100 {
            let x: u64 = random();
            let y: u64 = random();
            let x_big = BigUint::from_u64(x).unwrap();
            let y_big = BigUint::from_u64(y).unwrap();
            let result = karatsuba_multiplication( &x_big, &y_big, 64);
            assert_eq!(result, x_big*y_big);
        }
    }

}
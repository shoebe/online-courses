
struct Bound { //inclusive on both high and low
    high: usize,
    low: usize
}

impl Bound {
    fn new(low: usize, high: usize) -> Bound {
        Bound { low, high }
    }
}

pub fn merge_sort(arr: &mut Vec<usize>) {
    merge_sort_recur(arr, &Bound::new(0, arr.len()-1));
}

fn merge_sort_recur(arr: &mut Vec<usize>, bound: &Bound) {
    let dif = bound.high - bound.low;
    if dif == 0 { // 1 item long
        return
    }
    let num_mid_bound = dif / 2 + bound.low;
    // mid bound gets rounded down, if dif == 1, mid bound = bound.low
    let lower_array_bound = Bound::new(bound.low, num_mid_bound);
    let higher_array_bound = Bound::new(num_mid_bound+1, bound.high);
    merge_sort_recur(arr, &lower_array_bound);
    merge_sort_recur(arr, &higher_array_bound);

    merge(arr, &lower_array_bound, &higher_array_bound);

}

fn merge(arr: &mut Vec<usize>, b1: &Bound, b2: &Bound) {
    // copy the lower bound to avoid overriding values
    let low_len = b1.high - b1.low + 1;
    let mut low_copy: Vec<usize> = vec![0; low_len];
    low_copy.copy_from_slice(&arr[b1.low..(b1.high+1)]);
    // p1 reads from low_copy, p2 directly from arr, modify arr directly
    let mut p1 = 0;
    let mut p2 = b2.low;
    for i in b1.low..(b2.high+1) {
        if p2 > b2.high || p1 < low_len && low_copy[p1] < arr[p2] {
            arr[i] = low_copy[p1];
            p1 += 1;
        }
        else {
            arr[i] = arr[p2];
            p2 += 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand;


    fn randomize_vec(arr: &mut Vec<usize>) {
        for _i in 0..arr.capacity() {
            arr.push(rand::random());
        }
    }

    #[test]
    fn merge_sort_test() {
        let mut arr: Vec<usize> = Vec::with_capacity(1000000);
        randomize_vec(&mut arr);

        merge_sort(&mut arr);

        for i in 1..arr.len() {
            assert!(arr[i-1] < arr[i]);
        }
    }
}
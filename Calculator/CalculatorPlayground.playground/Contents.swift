//: Playground - noun: a place where people can play

import UIKit

var arr = [1,2,3,4,5,6,7,8,9,10]



for (index, item) in arr.enumerated() {
    if item % 2 == 0 {
        if let index = arr.index(of: item) {
            arr.remove(at: index)
            print(arr[1])
        }
    }
    print((index, item))
}

arr

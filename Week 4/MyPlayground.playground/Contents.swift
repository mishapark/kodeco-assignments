import Foundation

// a) In the assignment for Week 3, part D asked you to write a function that would compute the average of an array of Int. Using that function and the array created in part A, create two overloaded functions of the function average.

var nums1: [Int] = Array(0 ... 20)
var doubleNums: [Double] = Array(repeating: 5.5, count: 20)
let optionalArray: [Int]? = nil

func average(_ arr: [Int]?) {
  guard let numbers = arr else {
    print("The array is nil. Calculating the average is impossible.")
    return
  }

  let result = Double(numbers.reduce(0, +)) / Double(numbers.count)
  print("The average of the values in the array is \(result)")
}

func average(_ numbers: Int...) {
  let result = Double(numbers.reduce(0, +)) / Double(numbers.count)
  print("The average of the numbers is \(result)")
}

func average(_ arr: [Double]?) {
  guard let numbers = arr else {
    print("The array is nil. Calculating the average is impossible.")
    return
  }

  let result = numbers.reduce(0, +) / Double(numbers.count)
  print("The average of the double values in the array is \(result)")
}

average(optionalArray)
average(nums1)
average(doubleNums)
average(1, 2, 3, 4, 5, 6, 7, 8, 9, 0)

// b) Create an enum called Animal that has at least five animals. Next, make a function called theSoundMadeBy that has a parameter of type Animal. This function should output the sound that the animal makes. For example, if the Animal passed is a cow, the function should output, “A cow goes moooo.”
// Hint: Do not use if statements to complete this section.
// Call the function twice, sending a different Animal each time.

enum Animal {
  case cat, dog, bird, frog, fox
}

func theSoundMadeBy(_ animal: Animal) {
  switch animal {
  case .cat:
    print("Cat goes meow")
  case .dog:
    print("Dog goes woof")
  case .bird:
    print("Bird goes tweet")
  case .frog:
    print("Frog goes croak")
  case .fox:
    print("What does the fox say?")
    print("Wa-pa-pa-pa-pa-pa-pow!")
  }
}

theSoundMadeBy(.dog)
theSoundMadeBy(.cat)
theSoundMadeBy(.bird)
theSoundMadeBy(.fox)

// c) This question will have you creating multiple functions that will require you to use closures and collections. First, you will do some setup.
// Create an array of Int called nums with the values of 0 to 100.
// Create an array of Int? called numsWithNil with the following values: 79, nil, 80, nil, 90, nil, 100, 72
// Create an array of Int called numsBy2 with values starting at 2 through 100, by 2.
// Create an array of Int called numsBy4 with values starting at 2 through 100, by 4.

// You can set the values of the arrays above using whatever method you find the easiest. In previous weeks you were introduced to ranges and sequences in Swift. Leveraging those in the Array initializer will allow you to create the requested arrays in a single line. Don’t let the last two break your stride.

let nums: [Int] = Array(0 ... 100)
let numsWithNil: [Int?] = [79, nil, 80, nil, 90, nil, 100, 72]
let numsBy2: [Int] = Array(stride(from: 2, through: 100, by: 2))
let numsBy4: [Int] = Array(stride(from: 2, through: 100, by: 4))

// - Create a function called evenNumbersArray that takes a parameter of [Int] (array of Int) and returns [Int]. The array of Int returned should contain all the even numbers in the array passed. Call the function passing the nums array and print the output.

func evenNumbersArray(_ numbers: [Int]) -> [Int] {
  numbers.filter { $0 % 2 == 0 }
}

print("All even numbers \(evenNumbersArray(nums))")

// - Create a function called sumOfArray that takes a parameter of [Int?] and returns an Int. The function should return the sum of the array values passed that are not nil. Call the function passing the numsWithNil array, and print out the results.

func sumOfArray(_ optionalNumbers: [Int?]) -> Int {
  optionalNumbers.compactMap { $0 }.reduce(0, +)
}

print("Sum of numbers \(sumOfArray(numsWithNil))")

// - Create a function called commonElementsSet that takes two parameters of [Int] and returns a Set<Int> (set of Int). The function will return a Set<Int> of the values in both arrays.
// - Call the function commonElementsSet passing the arrays numsBy2, numsBy4, and print out the results.

func commonElementsSet(_ arr1: [Int], _ arr2: [Int]) -> Set<Int> {
  // Set([arr1, arr2].flatMap{$0})
  // or
  Set(arr1 + arr2)
}

print("Set of numbers \(commonElementsSet(numsBy2, numsBy4))")

// d) Create a struct called Square that has a stored property called sideLength and a computed property called area. Create an instance of Square and print the area.

struct Square {
  let sideLength: Double
  var area: Double {
    sideLength * sideLength
  }
}

print("Area of the square: \(Square(sideLength: 5).area)")

// Above and Beyond

// Create a protocol called Shape with a calculateArea() -> Double method. Create two structs called Circle and Rectangle that conform to the protocol Shape. Both Circle and Rectangle should have appropriate stored properties for calculating the area.

protocol Shape {
  func calculateArea() -> Double
}

struct Circle: Shape {
  let radius: Double

  func calculateArea() -> Double {
    Double.pi * radius * radius
  }
}

struct Rectangle: Shape {
  let length: Double
  let width: Double

  func calculateArea() -> Double {
    length * width
  }
}

// Create instances of Circle and Rectangle and print out the area for each.

print("Circle area: \(Circle(radius: 5).calculateArea())")
print("Rectangle area: \(Rectangle(length: 5, width: 10).calculateArea())")

// Next, extend the protocol Shape to add a new method called calculateVolume() -> Double.

extension Shape {
  func calculateVolume() -> Double {
    // Default Implementation
    0
  }
}

// Finally, create a struct called Sphere that conforms to Shape. Sphere should have appropriate stored properties for calculating area and volume.

struct Sphere: Shape {
  let radius: Double

  func calculateArea() -> Double {
    4 * Double.pi * radius * radius
  }

  func calculateVolume() -> Double {
    4 / 3 * Double.pi * pow(radius, 3)
  }
}

// Create an instance of Sphere and print the area and volume.

print("Sphere volume: \(Sphere(radius: 5).calculateVolume())")

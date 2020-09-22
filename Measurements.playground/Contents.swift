import Foundation

let distanceInMeters = 672.5

let distance = Measurement<UnitLength>(value: distanceInMeters, unit: .meters)
let distance2 = Measurement<UnitLength>(value: 21572, unit: .feet)

let totalDistance = distance + distance2

print(totalDistance)
print(distance2.converted(to: .meters))


func willOverheat(temp: Measurement<UnitTemperature>) -> Bool {
    return false
}

let angle1 = Measurement<UnitAngle>(value: .pi, unit: .radians)
let angle2 = Measurement<UnitAngle>(value: 45, unit: .degrees)
angle1.converted(to: .degrees)

let formatter = MeasurementFormatter()
let usLocale = Locale(identifier: "en-US")
let gbLocale = Locale(identifier: "en-GB")
let spLocale = Locale(identifier: "es-ES")

formatter.unitStyle = .short
//formatter.unitOptions = .temperatureWithoutUnit
formatter.locale = usLocale
//formatter.string(from: distance)
let temp = Measurement<UnitTemperature>(value: 24, unit: .kelvin)
formatter.string(from: temp)


let expires = Date().addingTimeInterval(60 * 60 * 24)
let expires2 = Date().adding(24.hours)

extension Date {
    func adding(_ measurement: Measurement<UnitDuration>) -> Date {
        let timeInterval = measurement.converted(to: .seconds).value
        return addingTimeInterval(timeInterval)
    }
}

extension Double {
    var hours: Measurement<UnitDuration> {
        Measurement(value: self, unit: UnitDuration.hours)
    }
    
    var minutes: Measurement<UnitDuration> {
        Measurement(value: self, unit: UnitDuration.minutes)
    }
    
    var seconds: Measurement<UnitDuration> {
        Measurement(value: self, unit: UnitDuration.seconds)
    }
}

extension UnitDuration {
    static let days = UnitDuration(symbol: "days", converter: UnitConverterLinear(coefficient: 60 * 60 * 24))
}

let today = Date()
let tomorrow = Date().adding(Measurement(value: 1, unit: UnitDuration.days))



// FACTORIO

protocol Entity {
    static var symbol: String { get }
}

struct IronPlate: Entity {
    static var symbol: String { "iron" }
}

struct CopperPlate: Entity {
    static var symbol: String { "copper" }
}

struct CopperWire: Entity {
    static var symbol: String { "copper-wire" }
}

final class Throughput<Item: Entity>: Dimension {
    static var itemsPerSecond: Throughput<Item> {
        Throughput<Item>(symbol: "\(Item.symbol)/s", converter: UnitConverterLinear(coefficient: 1))
    }
    
    static var itemsPerMinute: Throughput<Item> {
        Throughput<Item>(symbol: "\(Item.symbol)/m", converter: UnitConverterLinear(coefficient: 1/60))
    }
    
    override class func baseUnit() -> Self {
        return itemsPerSecond as! Self
    }
}

let ironMine1 = Measurement<Throughput<IronPlate>>(value: 542, unit: .itemsPerSecond)
let ironMine2 = Measurement<Throughput<IronPlate>>(value: 125, unit: .itemsPerMinute)

if ironMine1 > ironMine2 {
    print("Iron mine 1 is better")
} else {
    print("Iron mine 2 is better")
}

let totalIron = (ironMine1 + ironMine2).converted(to: .itemsPerMinute)

// 1 copper plate -> 2 copper wire every 0.5 s

struct ItemQuantity<Item: Entity> {
    let quantity: Int
}

struct Recipe<Input: Entity, Output: Entity> {
    
    let inputThroughput: Measurement<Throughput<Input>>
    let outputThroughput: Measurement<Throughput<Output>>
    
    init(input: ItemQuantity<Input>, output: ItemQuantity<Output>, duration: Measurement<UnitDuration>) {
        
        let seconds = duration.converted(to: .seconds).value
        
        inputThroughput = Measurement<Throughput<Input>>(value: Double(input.quantity) * seconds, unit: .itemsPerSecond)
        
        outputThroughput = Measurement<Throughput<Output>>(value: Double(output.quantity) * seconds, unit: .itemsPerSecond)
    }
}

let copperWire = Recipe<CopperPlate, CopperWire>(input: .init(quantity: 1), output: .init(quantity: 2), duration: Measurement(value: 0.5, unit: UnitDuration.seconds))

(copperWire.inputThroughput * 100).converted(to: .itemsPerMinute)
(copperWire.outputThroughput * 100).converted(to: .itemsPerMinute)


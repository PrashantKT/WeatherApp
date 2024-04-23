import UIKit

var greeting = "Hello, playground"

let dayLightStart = Calendar.current.date(bySettingHour: Int.random(in: 5...6), minute: Int.random(in: 0...59), second: 0, of: Date())!
let dayLightEnd = Calendar.current.date(bySettingHour: Int.random(in: 17...18), minute:Int.random(in: 0...59) , second: 0, of: Date())!
let currentTempDate = Calendar.current.date(bySettingHour: Int.random(in: 8...14), minute:Int.random(in: 0...59) , second: 0, of: Date())!



print(dayLightStart.formatted())
print(dayLightEnd.formatted())
print(currentTempDate.formatted())

print(currentTempDate.timeIntervalSince(dayLightStart))
print(currentTempDate.timeIntervalSince(dayLightStart).formatted())


let totalDaylightDuration = dayLightEnd.timeIntervalSince(dayLightStart)


let elapsedTimeSinceDaylightStart = currentTempDate.timeIntervalSince(dayLightStart)
let daylightPercentage = (elapsedTimeSinceDaylightStart / totalDaylightDuration) * 100
print("Daylight percentage: \(daylightPercentage)%")





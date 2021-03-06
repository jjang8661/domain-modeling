//
//  main.swift
//  DomainModeling(local)
//
//  Created by seowoosuk on 10/15/15.
//  Copyright © 2015 Woosuk Seo. All rights reserved.
//

import Foundation


//Money
protocol Mathematics {
    mutating func add(var Money:money)
    mutating func sub(var Money:money)
}

extension Double {
    var USD : money { return money(amount:self,currency:"USD")}
    var EUR : money { return money(amount:self,currency:"EUR")}
    var GBP : money { return money(amount:self,currency:"GBP")}
    var YEN : money { return money(amount:self,currency:"YEN")}
}

struct money : CustomStringConvertible, Mathematics{
    var amount : Double
    var currency : String
    
    var description: String {
        return "\(self.currency)\(amount)"
    }
    
    mutating func calcCurrency(amount:Double, curr1:String, curr2:String) -> Double {
        let GBP = 0.5
        let EUR = 1.5
        let CAN = 1.25
        
        if(curr1 == "USD") {
            switch curr2 {
            case "GBP" :
                self.currency = "GBP"
                return GBP
            case "EUR" :
                self.currency = "EUR"
                return EUR
            default /*"CAN"*/ :
                self.currency = "CAN"
                return CAN
            }
        } else if(curr1 == "GBP"){
            switch curr2 {
            case "USD" :
                self.currency = "USD"
                return 1/GBP
            case "EUR" :
                self.currency = "EUR"
                return EUR/GBP
            default /*"CAN"*/ :
                self.currency = "CAN"
                return CAN/GBP
            }
        }  else if(curr1 == "EUR"){
            switch curr2 {
            case "USD" :
                
                return 1/EUR
            case "GBP" :
                self.currency = "GBP"
                return GBP/EUR
            default /*"CAN"*/ :
                self.currency = "CAN"
                return CAN/EUR
            }
        }  else /*"CAN"*/{
            switch curr2 {
            case "USD" :
                self.currency = "USD"
                return 1/CAN
            case "EUR" :
                self.currency = "EUR"
                return EUR/CAN
            default /*"GBP"*/ :
                self.currency = "GBP"
                return GBP/CAN
            }
        }
    }
    
    mutating func convert(curr2:String) -> Void {
        let curr1 = self.currency
        if(curr2 == "GBP"||curr2=="EUR"||curr2=="CAN"||curr2=="USD") {
            self.amount *= calcCurrency(self.amount,curr1:curr1,curr2:curr2)
        } else {
            print("Invalid currency input")
            exit(0)
        }
    }
    
    
    mutating func add(var m2:money) -> Void {
        let curr1 = self.currency
        if(self.currency != m2.currency){
            m2.convert(curr1)
        }
        self.amount += m2.amount
    }
    
    mutating func sub(var m2:money) -> Void {
        let curr1 = self.currency
        if(self.currency != m2.currency){
            m2.convert(curr1)
        }
        self.amount -= m2.amount
    }
    
    
}


//Job

class Job : CustomStringConvertible{
    var title: String
    var salary: Double
    var salaryType: String
    
    init(title: String, salary:Double, salaryType:String){
        self.title = title
        self.salary = salary
        self.salaryType = salaryType
    }
    
    var description: String {
        return "\(self.title)(\(self.salary))"
    }
    
    func calcIncome(h:Double)->Double {
        let hours:Double? = h
        if(hours != nil){
            if(self.salaryType == "per-hour" ){
                return self.salary * hours!
            } else {
                return self.salary
            }
        } else {
            return self.salary
        }
    }
    
    func raise(percent:Double){
        let raised = self.salary * (percent/100)
        self.salary += raised
    }
}

var myJob = Job(title: "Programmer", salary:30, salaryType:"per-hour")


//Person

class Person : CustomStringConvertible{
    var firstName: String
    var lastName: String
    var age : Int
    var job: Job?
    var spouse: Person?
    
    var description : String {
        var fullString = firstName + " " + lastName
        
        if(self.age >= 16){
            if(self.job != nil){
                let selfInfo = "(" + job!.title + ","+"\(age))"
                fullString += selfInfo
            } else {
                let selfInfo = "(\(age))"
                fullString += selfInfo
            }
        } else {
            let selfInfo = "(\(age))"
            fullString += selfInfo
        }
        
        return fullString
    }
    
    init(firstName: String, lastName: String, age: Int, job:Job?, spouse:Person?){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
}


//Family
class Family : CustomStringConvertible {
    var members: [Person]
    var isLegal: Bool
    
    init(members:[Person],isLegal:Bool){
        self.members = members
        self.isLegal = isLegal
    }
    
    var description: String {
        var names = ""
        for member in members {
            names += " "+member.description
        }
        return names
    }
    
    func householdIncome() -> Double {
        var total = 0.0
        for member in self.members {
            if(member.job != nil){
                total += member.job!.calcIncome(2000)
            }
        }
        return total
    }
    
    func haveChild(fName:String) -> Void {
        isLegalthere()
        if(isLegal == true){
            let baby = Person(firstName: fName, lastName: members[0].lastName, age: 0, job:nil, spouse:nil)
            self.members.append(baby)
        }else{
            print("There must be one Person in the family who is over age 21 to be legal.")
        }
        
    }
    
    func isLegalthere() -> Void {
        for member in self.members {
            if(member.age > 21){
                isLegal = true
            }
        }
    }
    
}

//Part1 Unit Tests
print("<<Part1 Unit Tests>>")

//Test Money
var changeCurrency = "CAN"
var m1 = money (amount:1.0, currency:"GBP")
var m2 = money (amount:5.0, currency:"GBP")

print("Change currency from " + m1.currency + " to " + changeCurrency)
print(m1.description+" = ")
m1.convert(changeCurrency)
print(m1.description)

var m3 = money (amount:1.0, currency:"USD")
changeCurrency = "EUR"
print("Change currency from " + m3.currency + " to " + changeCurrency)
print(m3.description+" = ")
m3.convert(changeCurrency)
print(m3.description)

print("Add " + m2.currency + " to " + m1.currency)
print("\(m1.description) + \(m2.description)=")
m1.add(m2)
print(m1.description)

print("Sub " + m3.currency + " to " + m2.currency)
print("\(m2.description) - \(m3.description)=")
m2.sub(m3)
print(m2.description)

//Test Job
print("My job is " + myJob.title)
print("My salary is $\(myJob.salary)-" + myJob.salaryType)
print("My income for 1800hours is \(myJob.calcIncome(1800))")
myJob.raise(10)
print("If my salary is raised by 10%, it is $\(myJob.salary)-" + myJob.salaryType)

//Test Person
var me = Person(firstName: "Peter", lastName: "Seo", age: 23, job:Job(title:"Programmer",salary:25.0,salaryType:"per-hour"),spouse:nil)
var she = Person(firstName: "Sunny", lastName: "Seo", age: 23, job:Job(title:"Teacher",salary:15.0,salaryType:"per-hour"),spouse:nil)

me.spouse = she
var bro = Person(firstName: "Albert", lastName: "Seo", age: 14, job:nil,spouse:nil)
var sis = Person(firstName: "Sonya", lastName: "Seo", age: 18, job:nil,spouse:nil)
print("My name is " + me.description)
print(me.spouse!.description + " is my spouse")
print("I have one borther and sister: " + bro.description + " and " + sis.description)


//Test Family
var family = Family(members:[me,she,bro,sis],isLegal:true)
print("My family consists of " + family.members[0].description + " ," + family.members[1].description + " ," +  family.members[2].description + " and " +  family.members[3].description)
print("Our family income is approximately \(family.householdIncome())")
family.haveChild("John")
print("We have a new baby whose name is " + family.members.last!.description)


//Part2 Unit Tests
print(" ")
print("<<Part2 Unit Tests>>")
print("<<Money Description Test>>")
var m4 = money (amount:3.0, currency:"GBP")
print(m1.description+" "+m2.description+" "+m3.description+" "+m4.description)
print("<<Job Description Test>>")
print(myJob.description)
print("<<Person Description Test>>")
print(me.description)
print(she.description)
print("<<Family Description Test>>")
print(family.description)

print("<<Mathematics Test>>")
print(m1.description + "+" + m2.description + "= ")
m1.add(m2)
print(m1.description)
print(m2.description + "+" + m3.description + "= ")
m2.add(m3)
print(m2.description)
print(m1.description + "-" + m3.description + "= ")
m1.sub(m3)
print(m1.description)
print(m2.description + "-" + m4.description + "= ")
m2.sub(m4)
print(m2.description)

print("<<Extension Test>>")
print(3.USD)
print(4.EUR)
print(12.GBP)
print(23.YEN)

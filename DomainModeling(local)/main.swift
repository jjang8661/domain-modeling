//
//  main.swift
//  DomainModeling(local)
//
//  Created by seowoosuk on 10/15/15.
//  Copyright © 2015 Woosuk Seo. All rights reserved.
//

import Foundation

//Money 

struct money {
    var amount : Double
    var currency : String
    
    func stringRep() -> String {
        return "\(self.amount)(\(self.currency))"
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

//Test
var changeCurrency = "CAN"
var m1 = money (amount:1.0, currency:"GBP")
var m2 = money (amount:5.0, currency:"GBP")

print("Change currency from " + m1.currency + " to " + changeCurrency)
print(m1.stringRep()+" = ")
m1.convert(changeCurrency)
print(m1.stringRep())

var m3 = money (amount:1.0, currency:"USD")
changeCurrency = "EUR"
print("Change currency from " + m3.currency + " to " + changeCurrency)
print(m3.stringRep()+" = ")
m3.convert(changeCurrency)
print(m3.stringRep())

print("Add " + m2.currency + " to " + m1.currency)
print("\(m1.stringRep()) + \(m2.stringRep())=")
m1.add(m2)
print(m1.stringRep())

print("Sub " + m3.currency + " to " + m2.currency)
print("\(m2.stringRep()) - \(m3.stringRep())=")
m2.sub(m3)
print(m2.stringRep())


//Job

class Job {
    var title: String
    var salary: Double
    var salaryType: String
    
    init(title: String, salary:Double, salaryType:String){
        self.title = title
        self.salary = salary
        self.salaryType = salaryType
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

//Test
print("My job is " + myJob.title)
print("My salary is $\(myJob.salary)-" + myJob.salaryType)
print("My income for 1800hours is \(myJob.calcIncome(1800))")
myJob.raise(10)
print("If my salary is raised by 10%, it is $\(myJob.salary)-" + myJob.salaryType)


//Person

class Person{
    var firstName: String
    var lastName: String
    var age : Int
    var job: Job?
    var spouse: Person?
    
    func toString()-> String {
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


var me = Person(firstName: "Peter", lastName: "Seo", age: 23, job:Job(title:"Programmer",salary:25.0,salaryType:"per-hour"),spouse:nil)
var she = Person(firstName: "Sunny", lastName: "Seo", age: 23, job:Job(title:"Teacher",salary:15.0,salaryType:"per-hour"),spouse:nil)

me.spouse = she

var bro = Person(firstName: "Albert", lastName: "Seo", age: 14, job:nil,spouse:nil)
var sis = Person(firstName: "Sonya", lastName: "Seo", age: 18, job:nil,spouse:nil)

print("My name is " + me.toString())
print(me.spouse!.toString() + " is my spouse")
print("I have one borther and sister: " + bro.toString() + " and " + sis.toString())


//Family

class Family{
    var members: [Person]
    var isLegal: Bool
    
    init(members:[Person],isLegal:Bool){
        self.members = members
        self.isLegal = isLegal
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

    var family = Family(members:[me,she,bro,sis],isLegal:true)

print("My family consists of " + family.members[0].toString() + " ," + family.members[1].toString() + " ," +  family.members[2].toString() + " and " +  family.members[3].toString())
print("Our family income is approximately \(family.householdIncome())")
family.haveChild("John")
print("We have a new baby whose name is " + family.members.last!.toString())
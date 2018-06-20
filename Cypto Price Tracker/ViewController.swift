//
//  ViewController.swift
//  Cypto Price Tracker
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 MustafaHussain. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON

class ViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    var finalURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var newFinalURL = ""
    var newCurrencyArray = ["BTC","ETH","LTC","BCH","XRP","XMR","ZEC"]
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return newCurrencyArray.count
        } else {
            return currencyArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return newCurrencyArray[row]
        } else {
            return currencyArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            finalURL = baseURL + newCurrencyArray[row]
        } else {
            newFinalURL = finalURL + currencyArray[row]
            currencySelected = currencySymbol[row]
        }
        getCurrencyData(url: newFinalURL)
    }
    
    func getCurrencyData(url:String){
        Alamofire.request(newFinalURL , method : .get).responseJSON {
            response in
            if response.result.isSuccess {
                let currencyJSON:JSON = JSON(response.result.value!)
                self.updateCurrencyData(json: currencyJSON)
            } else {
                self.priceLabel.text = "Connection Issue"
            }
        }
    }
    
    func updateCurrencyData(json:JSON){
        if let result = json["ask"].double {
            priceLabel.text = currencySelected + String(result)
        } else {
             priceLabel.text = "Price Unavailable"
        }
    }

}


//
//  GameViewController.swift
//  RestaurantMap
//
//  Created by Sebin Kwon on 1/8/25.
//

import UIKit

final class GameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var clapTextView: UITextView!
    @IBOutlet var resultLabel: UILabel!
    let pickerView = UIPickerView()
    let numberList = Array(1...100).reversed().map { String($0) }
    var maxNumber = 1
    var countClap = 0
    var resultText: String {
        "숫자 \(maxNumber)까지 총 박수는\n\(countClap)번 입니다."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        configureUI()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        clapTextView.text = ""
        countClap = 0
        guard let max = Int(numberList[row]) else { return }
        guard clapTextView.text != nil else { return }
        maxNumber = max
        changeNumToClap(max: max)
        resultLabel.text = resultText
    }
    
    private func changeNumToClap(max: Int) {
        guard clapTextView.text != nil else { return }
        let range = 1...max
        for i in range {
            let strNumArray = Array(String(i))
            var clapNum = ""
            for strNum in strNumArray {
                if strNum == "3" || strNum == "6" || strNum == "9" {
                    clapNum += "👏"
                    countClap += 1
                } else {
                    clapNum += String(strNum)
                }
            }
            if i != max {
                clapNum += ", "
            }
            clapTextView.text += clapNum
        }
    }
    
    private func configureUI() {
        titleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        textField.tintColor = .clear
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "최대 숫자를 입력해주세요", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 25),
            .paragraphStyle: centeredParagraphStyle
        ])
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        clapTextView.textAlignment = .center
        clapTextView.isEditable = false
        clapTextView.isScrollEnabled = false
        clapTextView.textColor = .systemGray3
        clapTextView.font = .systemFont(ofSize: 20, weight: .medium)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.font = .systemFont(ofSize: 35, weight: .bold)
    }
    
    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        numberList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numberList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
}

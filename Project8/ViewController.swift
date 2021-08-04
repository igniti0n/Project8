//
//  ViewController.swift
//  Project8
//
//  Created by Ivan Stajcer on 04.08.2021..
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel : UILabel!
    var cluesLabel : UILabel!
    var answersLabel : UILabel!
    var answerText : UITextField!
    var buttons = [UIButton]()
    var answers = [String]()
    
    var activeButtons = [UIButton]()
    var level = 1
    var correctWords = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 34)
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "CLUES"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1.0), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 34)
        answersLabel.numberOfLines = 0
        answersLabel.text = "ANSWERS"
        answersLabel.setContentHuggingPriority(UILayoutPriority(1.0), for: .vertical)
        view.addSubview(answersLabel)
        
        answerText = UITextField()
        answerText.translatesAutoresizingMaskIntoConstraints = false
        answerText.isUserInteractionEnabled = true
        answerText.isEnabled = false
        answerText.textAlignment = .center
        answerText.placeholder = "TAP LETTERS TO GUESS"
        answerText.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(answerText)
        
        let submit = UIButton(type: .system, primaryAction: nil)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        
        let clear = UIButton(type: .system, primaryAction: nil)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        clear.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        
        view.addSubview(submit)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let buttonWidth = 150
        let buttonHeight = 70
        
        for row in 0..<4 {
            for column in 0..<5{
                let newButton = UIButton(type: .system)
                newButton.setTitle("WWW", for: .normal)
                newButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                newButton.layer.borderWidth = 1
                newButton.layer.borderColor = UIColor.lightGray.cgColor
                newButton.frame = CGRect(x: buttonWidth * column, y: buttonHeight * row, width: buttonWidth, height: buttonHeight)
                newButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                buttons.append(newButton)
                buttonsView.addSubview(newButton)
            }
        }
        
        
        
        //CONTRAINTS
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: 10),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 20),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.leadingAnchor.constraint(equalTo: cluesLabel.trailingAnchor),
            answersLabel.centerYAnchor.constraint(equalTo: cluesLabel.centerYAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            
            answerText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerText.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 10),
            
            submit.topAnchor.constraint(equalTo: answerText.bottomAnchor, constant: 10),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 20),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //        answersLabel.backgroundColor = UIColor.blue
        //        cluesLabel.backgroundColor = UIColor.red
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadGame()
    }
    
    @objc private func submitAnswer(_ sender: UIButton){
        guard let answer = answerText.text else {return}
        
        if let answerIndex = answers.firstIndex(of: answer) {
            
            var answersString = answersLabel.text?.components(separatedBy: "\n")
            answersString?[answerIndex] = answers[answerIndex]
            answersLabel.text = answersString?.joined(separator: "\n")
            
            activeButtons.removeAll(keepingCapacity: true)
            
            score += 1
            correctWords += 1
            answerText.text = ""
            
            if correctWords % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "You have finished this level.", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Done.", style: .default))
                
                level += 1
                correctWords = 0
                self.present(ac, animated: true, completion: nil)
                loadGame()
            }
            
        }else{
            score -= 1
            
            let ac = UIAlertController(title: "Wrong guess!", message: "Score reduced by 1", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Done.", style: .default))
            self.present(ac, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func clearAll(_ sender: UIButton){
        answerText.text = ""
        for button in activeButtons {
            button.isHidden = false
        }
        activeButtons.removeAll(keepingCapacity: true)
    }
    
    @objc private func buttonPressed(_ sender: UIButton){
        
        guard let buttonText = sender.titleLabel?.text else {return}
        activeButtons.append(sender)
        answerText.text?.append(buttonText)
        sender.isHidden = true
        
    }
    
    private func loadGame(){
        var cluesString = ""
        var answersString = ""
        var wordBits = [String]()
        
        answers.removeAll(keepingCapacity: true)
        
        if let fileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: ".txt"){
            if let loadedString = try? String(contentsOf: fileUrl) {
                
                let lines = loadedString.components(separatedBy: "\n")
                
                for (index, line) in lines.enumerated() {
                    let seperatedString = line.components(separatedBy: ":")
                    
                    let answer :String = seperatedString[0]
                    let clue : String = seperatedString[1]
                    
                    cluesString.append("\(index + 1). \(clue)\n")
                    
                    let answerWords = answer.components(separatedBy: "|")
                    wordBits.append(contentsOf: answerWords)
                    
                    let currentAnswer = answerWords.joined()
                    answersString.append("\(currentAnswer.count) words \n")
                    answers.append(currentAnswer)
                }
                
            }
        }
        
        answersString = answersString.trimmingCharacters(in: .whitespacesAndNewlines)
        cluesString =  cluesString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        answersLabel.text = answersString
        cluesLabel.text = cluesString
        
        wordBits.shuffle()
        
        if wordBits.count == buttons.count {
            for (index, word) in wordBits.enumerated() {
                
                buttons[index].setTitle(word, for: .normal)
                buttons[index].isHidden = false
            }
        }
        
    }
    
    
}


//
//  ViewController.swift
//  Day41Challenge
//
//  Created by 川野智史 on 2021/10/27.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedLetters = [String]()
    var word = ""
    var promptWord = ""
    var wrongAnswersCount = 0
    var lastHitCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silworm"]
        }
        
        startGame()
    }
    
    // MARK: - Functions
    @objc func startGame() {
        word = allWords.randomElement()?.uppercased() ?? "RHYTHM"
        usedLetters.removeAll()
        wrongAnswersCount = 0
        lastHitCount = 0
        promptWord = ""
        
        for _ in word {
            promptWord += "?"
        }
        title = "\(promptWord) \(wrongAnswersCount)/7 miss"
        
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer Character", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let upperAnswer = answer.uppercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if upperAnswer.count == 1 {
            usedLetters.append(upperAnswer)
            updatePromptWord()
            
            return
        } else {
            errorTitle = "Input error"
            errorMessage = "Please 1 character."
        }
        
        showErrorMessage(title: errorTitle, message: errorMessage)
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func updatePromptWord() {
        promptWord = ""
        var currentHitCount = 0
        
        for letter in word {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                promptWord += strLetter
                currentHitCount += 1
            } else {
                promptWord += "?"
            }
        }
        
        if currentHitCount == lastHitCount {
            wrongAnswersCount += 1
        } else {
            lastHitCount = currentHitCount
        }
        
        title = "\(promptWord) \(wrongAnswersCount)/7 miss"
        tableView.reloadData()
        judgeEndGame()
    }
    
    func judgeEndGame() {
        let title = "Game End"
        var message = ""
        
        if wrongAnswersCount >= 7 {
            message = "Your Lose!"
        } else if !promptWord.contains("?") {
            message = "Your Win!"
        } else {
            return
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - UITableViewControllerDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedLetters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedLetters[indexPath.row]
        return cell
    }
}

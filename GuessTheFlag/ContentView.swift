//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maurício Costa on 06/01/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var round = 0
    @State private var gameOver = false
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag").font(.largeTitle.weight(.bold)).foregroundColor(.white)
                Spacer()
                Spacer()
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").font(.subheadline.weight(.heavy)).foregroundStyle(.secondary)
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                           flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original).clipShape(Capsule()).shadow(radius: 5)
                        }
                        .alert(scoreTitle, isPresented: $gameOver) {
                            Button("Restart game", action: restartGame) } message: {
                        Text("Game over! Your score was \(totalScore)")
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }.alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion) } message: {
                    Text("Your score is \(totalScore)")
                }.padding()
            }
        }
    }
    func flagTapped(_ number: Int) {
            if number == correctAnswer {
                scoreTitle = "Correct"
                totalScore += 1
            } else {
                scoreTitle = "Wrong! That's the flag of \(countries[number])"
            }
            showingScore = true
            round += 1
        if round == 8 {
            gameOver = true
            scoreTitle = "Game Over!"
        }
        }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func restartGame() {
        totalScore = 0
        round = 0
        gameOver = false
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

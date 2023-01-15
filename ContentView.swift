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
    @State private var gameOverTitle = ""
    @State private var gameOver = false
    @State private var animationAmount = 0.0
    @State private var animating = false
    
    struct FlagImage: View {
        var image: String
        var body: some View {
            Image(image)
                .renderingMode(.original).clipShape(Capsule()).shadow(radius: 5)
        }
    }
    
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
                            withAnimation {
                                animationAmount += 360
                            }
                        } label: {
                            FlagImage(image: countries[number]).rotation3DEffect(.degrees((number == correctAnswer && animating) ? animationAmount : 0), axis: (x:0,y:1,z:0))
                                .opacity((number != correctAnswer && animating) ? 0.3 : 1)
                                .scaleEffect((number != correctAnswer && animating) ? 0.75 : 1)
                        }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }.alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion) } message: {
                    Text("Your score is \(totalScore)")
                }.padding()
                    .alert(gameOverTitle, isPresented: $gameOver) {
                        Button("Restart game", action: restartGame) } message: {
                    Text("Your score was \(totalScore)")
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
            animating = true
            showingScore = true
            round += 1
        if round == 8 {
            gameOver = true
            gameOverTitle = "Game Over!"
        }
        }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animating = false
    }
    func restartGame() {
        totalScore = 0
        round = 0
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

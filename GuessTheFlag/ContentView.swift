//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ali Khorramipour on 1/3/23.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(color: .black, radius: 2)
            .overlay(Capsule()
            .stroke(Color.black, lineWidth: 1))
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    // game is over after 5 questions
    @State private var gameOver = false
    @State private var questionsAnswered = 0
    
    @State private var rotationAmount = [Double](repeating: 0.0, count: 3)
    @State private var opacityAmount = [Double](repeating: 1.0, count: 3)
    @State private var scaleAmount = [Double](repeating: 1.0, count: 3)
    
    
    var body: some View {
        ZStack{
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                            withAnimation{
                                rotationAmount[number] += 360
                                for _number in 0..<3 where _number != number {
                                    opacityAmount[_number] = 0.75
                                    scaleAmount[_number] *= 0.75
                                }
                            }
                        } label:{
                            Image(countries[number])
                                .renderingMode(.original)
                                .modifier(FlagImage())
                                .opacity(opacityAmount[number])
                                .scaleEffect(scaleAmount[number])
                                .rotation3DEffect(.degrees(rotationAmount[number]), axis: (x: 0.0, y: 1.0, z: 0.0))
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 33))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Answered: \(questionsAnswered)/5")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
            }
            .padding()
            // alert after game is over
            .alert(scoreTitle, isPresented: $gameOver){
                Button("Restart", action: start)
            } message: {
                Text("Game Over!\nYour final score is \(score)/5")
            }
            // alert after each answer
            .alert(scoreTitle, isPresented: $showingScore){
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct!"
            score += 1
            questionsAnswered += 1
            
        } else {
            scoreTitle = "Incorrect! That was \(countries[number])!"
            score -= 1
            questionsAnswered += 1
        }
        showingScore = true
        
        if questionsAnswered == 5 {
            gameOver = true
            showingScore = false
        }
    }
    
    func askQuestion(){
        rotationAmount = [Double](repeating: 0.0, count: 3)
        opacityAmount = [Double](repeating: 1.0, count: 3)
        scaleAmount = [Double](repeating: 1.0, count: 3)
        while true{
            countries.shuffle()
            let previousCorrectAnswer = correctAnswer
            correctAnswer = Int.random(in: 0...2)
            if countries[previousCorrectAnswer] != countries[correctAnswer]{
                break
            }
        }
    }
    
    func start(){
        countries.shuffle()
        score = 0
        questionsAnswered = 0
        gameOver = false
        showingScore = false
        rotationAmount = [Double](repeating: 0.0, count: 3)
        opacityAmount = [Double](repeating: 1.0, count: 3)
        scaleAmount = [Double](repeating: 1.0, count: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

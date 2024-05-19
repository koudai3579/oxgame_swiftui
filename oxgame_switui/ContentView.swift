import SwiftUI

//構造体は値型であるため、参照型のクラスよりも安全にデータを扱える
enum Player: String {
    case x = "X"
    case o = "O"
}

struct ContentView: View {
    
    @State private var currentPlayer: Player = .x
    @State private var winner: Player?
    @State private var isWinnerAlertPresented = false
    @State private var isDraw: Bool = false
    @State private var alertTitle = "title"
    @State private var currectTopLabelColor:Color = .red
    @State private var cells: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    
    init() {
        //ナビゲーションバーの背景色を追加
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        //ナビゲーションを使用する場合、全体のビューを囲む
        NavigationView {
            
            //VStack:Viewを縦に配置
            VStack(alignment: .center, spacing: 0.0) {
                
                Text("\(currentPlayer.rawValue)のターン")
                    .font(.system(size: 40))
                    .foregroundColor(currectTopLabelColor)
                    .padding(EdgeInsets(top: 40, leading: 1, bottom: 40, trailing: 0)) // カスタムの四方向の余白を追加
                
                //ForEachを使うことで縦横3つずつボタンを配置
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 0.0) {
                        ForEach(0..<3, id: \.self) { column in
                            Button(action: {
                                oxButtonTapped(row: row, column: column)
                            }){
                                Text(cells[row][column]?.rawValue ?? "")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .frame(width: 100, height: 100)
                                    .border(Color.white, width: 1)
                                    .foregroundColor(.white)
                                    .background(currectTileColor(row, column))
                            }
                        }
                    }
                }
                
                Button(action: {
                    GameResset()
                }){
                    Text("ゲームをやり直し")
                        .bold()
                        .padding()
                        .font(.system(size: 25))
                        .frame(width: 300, height: 80)
                        .foregroundColor(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.purple, lineWidth: 5)
                        )
                }.padding(.top,30)
                
                    .alert(isPresented: $isWinnerAlertPresented) {
                        Alert(title: Text(alertTitle),message: nil,dismissButton: .default(Text("ゲームをリセット"),action: {GameResset()})
                        )
                    }
                Spacer() //1番後ろでSpacerを使うことでVStackのビューを上寄せ可能
            }
            //ナビゲーションバータイトル
            .navigationBarTitle("◯✗Game", displayMode: .inline)
        }
    }
    
    func oxButtonTapped(row:Int,column:Int){
        
        //既にoxが入力されていた場合はここで処理を停止し上書きできなようにする
        if cells[row][column] != nil{return}
        //選択されたセルに現在のプレイヤーの◯✗を代入
        cells[row][column] = currentPlayer
        
        //現在のマス目の状況について、勝者がいるか確認
        //①列を確認
        for row in 0..<3 {
            //(ロジック)各列について、cells[row][0]のプレイヤーを定義した時、そのプレイヤーが[row][1]と[row][2]と同じならば勝者が決定する
            if let player = cells[row][0], cells[row][1] == player, cells[row][2] == player {
                winner = player
                alertTitle = "\(currentPlayer.rawValue)の勝利！"
                isWinnerAlertPresented = true
                return
            }
        }
        
        //②行を確認
        for column in 0..<3 {
            if let player = cells[0][column], cells[1][column] == player, cells[2][column] == player {
                winner = player
                alertTitle = "\(currentPlayer.rawValue)の勝利！"
                isWinnerAlertPresented = true
                return
            }
        }
        
        //③斜め(\)を確認
        if let player = cells[0][0], cells[1][1] == player, cells[2][2] == player {
            winner = player
            alertTitle = "\(currentPlayer.rawValue)の勝利！"
            isWinnerAlertPresented = true
            return
        }
        
        //④斜め(/)を確認
        if let player = cells[0][2], cells[1][1] == player, cells[2][0] == player {
            winner = player
            alertTitle = "\(currentPlayer.rawValue)の勝利！"
            isWinnerAlertPresented = true
            return
        }
        
        //⑤引き分けを確認
        //flatMapメソッドで二次元配列cellsを一次元配列に変換し、変換した結果にcontains(nil)を使用して、配列の中にnilが含まれているかを確認
        if cells.flatMap({ $0 }).contains(nil) == false {
            isDraw = true
            alertTitle = "引き分けです"
            isWinnerAlertPresented = true
        }
        
        //現在のプレイヤーが "X" であれば "O" に、"O" であれば "X" に切り替えて相手のターンへ(三項演算子)
        currentPlayer = currentPlayer == .x ? .o : .x
        CheckCurrectTopLabelColor()
    }
    
    //ゲーム情報の初期化
    func GameResset() {
        currentPlayer = .x
        CheckCurrectTopLabelColor()
        cells = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        winner = nil
        isDraw = false
    }
    
    //3×3の各マスの中身(String)について、xなら赤色を、oなら青色を、nilならグレーを返す
    func currectTileColor(_ row:Int,_ column:Int)->Color{
        if cells[row][column] == .x {
            return .red
        }else if cells[row][column] == .o {
            return .blue
        }
        return .gray
    }
    
    //現在のプレイヤーによってトップのラベルの色を更新
    func CheckCurrectTopLabelColor(){
        if currentPlayer == .x {
            currectTopLabelColor = .red
        }else{
            currectTopLabelColor = .blue
        }
    }
}

#Preview {
    ContentView()
}

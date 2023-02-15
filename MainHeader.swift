//
//  MainHeader.swift
//  ChattyGPT
//
//  Created by Mingchung Xia on 2023-02-15.
//

import SwiftUI

struct MainHeader: View {
    var body: some View {
        HStack {
            Spacer()
            Text("KnowNow")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
    }
}

struct MainHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainHeader()
    }
}

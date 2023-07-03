//
//  AboutView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/3/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List{
            Section {
                Link(destination: URL(string: "http://www.zachtarvin.com")!) {
                    Label("My Website", systemImage: "safari.fill")
                }
                Link(destination: URL(string: "http://www.twitter.com/themrzt")!) {
                    Label("Twitter", systemImage: "bird.fill")
                }
                Link(destination: URL(string: "http://www.mastodon.social/@themrzt")!) {
                    Label("Mastodon", systemImage: "bubble.left.fill")
                }
            } header: {
                Text("Made for fun in Chicago")
            }
        }.navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

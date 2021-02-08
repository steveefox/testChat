//
//  SelfConfiguringCell.swift
//  testChatMessageKit
//
//  Created by Nikita on 7.02.21.
//



protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}

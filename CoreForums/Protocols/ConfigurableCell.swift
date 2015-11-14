//
//  ConfigurableCell.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

protocol ConfigurableCell {
    typealias DataSource
    func configureForObject(object: DataSource)
}
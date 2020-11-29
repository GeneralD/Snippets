//
//  FunctionalFunctions.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/11/28.
//  Copyright © 2020 ZYXW. All rights reserved.
//

/// remove autoclosuring from the function
prefix func !<T>(_ f: @escaping (@autoclosure () throws -> T) throws -> T) -> (T) throws -> T {
	{ try f($0) }
}

/// remove autoclosuring from the function
prefix func !<T, U, V>(_ f: @escaping (@autoclosure () throws -> T, U) throws -> V) -> (T, U) throws -> V {
	{ try f($0, $1) }
}

/// remove autoclosuring from the function
prefix func !<T, U, V>(_ f: @escaping (T, @autoclosure () throws -> U) throws -> V) -> (T, U) throws -> V {
	{ try f($0, $1) }
}

/// remove autoclosuring from the function
prefix func !<T, U, V>(_ f: @escaping (@autoclosure () throws -> T, @autoclosure () throws -> U) throws -> V) -> (T, U) throws -> V {
	{ try f($0, $1) }
}

func ??<T, Result>(_ f: @escaping (T) throws -> Result, _ alt: Result) -> (T?) throws -> Result {
	{ opt in
		guard let t = opt else { return alt }
		return try f(t)
	}
}

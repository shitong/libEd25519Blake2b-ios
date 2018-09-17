//
//  Extension.swift
//  libEd25519Blake2b_ExampleTests
//
//  Created by Stone on 2018/9/17.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import libEd25519Blake2b

extension Array where Element == UInt8 {

    public var utf8String: String? {
        return String(data: Data(bytes: self), encoding: .utf8)
    }

    public var hexString: String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}

extension ArraySlice where Element == UInt8 {
    var bytes: Bytes { return Bytes(self) }
}

public extension String {
    var bytes: Bytes { return Bytes(self.utf8) }
    var hex2Bytes: Bytes {

        if self.unicodeScalars.lazy.underestimatedCount % 2 != 0 {
            return []
        }

        var bytes = Bytes()
        bytes.reserveCapacity(self.unicodeScalars.lazy.underestimatedCount / 2)

        var buffer: UInt8?
        var skip = self.hasPrefix("0x") ? 2 : 0
        for char in self.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                return []
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                return []
            }
            if let b = buffer {
                bytes.append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            bytes.append(b)
        }

        return bytes
    }
}

import Foundation

/// Indicates the presence of a value, supporting both `nil` and `null` values.
///
/// In GraphQL, explicitly providing a `null` value for an input value to a field argument is
/// semantically different from not providing a value at all (`nil`). This enum allows you to
/// distinguish your input values between `null` and `nil`.
///
/// - See: [GraphQLSpec - Input Values - Null Value](http://spec.graphql.org/June2018/#sec-Null-Value)
@dynamicMemberLookup
public enum GraphQLNullable<Wrapped>: ExpressibleByNilLiteral {

  /// The absence of a value.
  /// Functionally equivalent to `nil`.
  case none

  /// The presence of an explicity null value.
  /// Functionally equivalent to `NSNull`
  case null

  /// The presence of a value, stored as `Wrapped`
  case some(Wrapped)

  public var unwrapped: Wrapped? {
    guard case let .some(wrapped) = self else { return nil }
    return wrapped
  }

  public subscript<T>(dynamicMember path: KeyPath<Wrapped, T>) -> T? {
    unwrapped?[keyPath: path]
  }

  public init(nilLiteral: ()) {
    self = .none
  }  
}

// MARK: - ExpressibleBy Literal Extensions

extension GraphQLNullable: ExpressibleByUnicodeScalarLiteral
where Wrapped: ExpressibleByUnicodeScalarLiteral {
  public init(unicodeScalarLiteral value: Wrapped.UnicodeScalarLiteralType) {
    self = .some(Wrapped(unicodeScalarLiteral: value))
  }
}

extension GraphQLNullable: ExpressibleByExtendedGraphemeClusterLiteral
where Wrapped: ExpressibleByExtendedGraphemeClusterLiteral {
  public init(extendedGraphemeClusterLiteral value: Wrapped.ExtendedGraphemeClusterLiteralType) {
    self = .some(Wrapped(extendedGraphemeClusterLiteral: value))
  }
}

extension GraphQLNullable: ExpressibleByStringLiteral
where Wrapped: ExpressibleByStringLiteral {
  public init(stringLiteral value: Wrapped.StringLiteralType) {
    self = .some(Wrapped(stringLiteral: value))
  }
}

extension GraphQLNullable: ExpressibleByIntegerLiteral
where Wrapped: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Wrapped.IntegerLiteralType) {
    self = .some(Wrapped(integerLiteral: value))
  }
}

extension GraphQLNullable: ExpressibleByFloatLiteral
where Wrapped: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Wrapped.FloatLiteralType) {
    self = .some(Wrapped(floatLiteral: value))
  }
}

extension GraphQLNullable: ExpressibleByBooleanLiteral
where Wrapped: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: Wrapped.BooleanLiteralType) {
    self = .some(Wrapped(booleanLiteral: value))
  }
}

extension GraphQLNullable: ExpressibleByArrayLiteral
where Wrapped: _InitializableByArrayLiteralElements {
  public init(arrayLiteral elements: Wrapped.ArrayLiteralElement...) {
    self = .some(Wrapped(elements))
  }
}

extension GraphQLNullable: ExpressibleByDictionaryLiteral
where Wrapped: _InitializableByDictionaryLiteralElements {
  public init(dictionaryLiteral elements: (Wrapped.Key, Wrapped.Value)...) {
    self = .some(Wrapped(elements))
  }
}

public protocol _InitializableByArrayLiteralElements: ExpressibleByArrayLiteral {
  init(_ array: [ArrayLiteralElement])
}
extension Array: _InitializableByArrayLiteralElements {}

public protocol _InitializableByDictionaryLiteralElements: ExpressibleByDictionaryLiteral {
  init(_ elements: [(Key, Value)])
}
extension Dictionary: _InitializableByDictionaryLiteralElements {
  public init(_ elements: [(Key, Value)]) {
    self.init(uniqueKeysWithValues: elements)
  }
}

// MARK: - Custom Type Initialization

public extension GraphQLNullable where Wrapped: RawRepresentable, Wrapped.RawValue == String {
  init(_ rawValue: String) {
    self = .some(Wrapped(rawValue: rawValue)!)
  }
}
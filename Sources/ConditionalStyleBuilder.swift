//
//  ConditionalStyleBuilder.swift
//  Rainbow
//
//  Created by Wei Wang on 15/12/23.
//
//  Copyright (c) 2018 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

/// A builder for applying multiple conditional styles to a string.
/// This class provides a fluent interface for building complex conditional styling scenarios.
public class ConditionalStyleBuilder {
    private let text: String
    private var steps: [(condition: Bool, transform: (String) -> String)] = []
    
    /// Initializes a new conditional style builder with the given text.
    /// - Parameter text: The text to apply conditional styles to.
    init(text: String) {
        self.text = text
    }
    
    /// Creates a conditional step that will apply transformations if the condition is true.
    /// - Parameter condition: The condition to evaluate.
    /// - Returns: A `ConditionalStyleStep` for chaining style applications.
    public func when(_ condition: Bool) -> ConditionalStyleStep {
        return ConditionalStyleStep(builder: self, condition: condition)
    }
    
    /// Creates a conditional step based on a closure predicate.
    /// - Parameter predicate: A closure that returns true if the styles should be applied.
    /// - Returns: A `ConditionalStyleStep` for chaining style applications.
    public func when(_ predicate: () -> Bool) -> ConditionalStyleStep {
        return ConditionalStyleStep(builder: self, condition: predicate())
    }
    
    /// Adds a transformation step to the builder.
    /// - Parameters:
    ///   - condition: The condition for applying the transformation.
    ///   - transform: The transformation to apply if the condition is true.
    func addStep(condition: Bool, transform: @escaping (String) -> String) {
        steps.append((condition, transform))
    }
    
    /// Builds the final string by applying all conditional transformations.
    /// - Returns: The string with all applicable conditional styles applied.
    public func build() -> String {
        var result = text
        for step in steps {
            if step.condition {
                result = step.transform(result)
            }
        }
        return result
    }
}

/// Represents a conditional step in the style building process.
/// This class provides methods to apply various styles when a condition is met.
public class ConditionalStyleStep {
    private let builder: ConditionalStyleBuilder
    private let condition: Bool
    
    /// Initializes a new conditional style step.
    /// - Parameters:
    ///   - builder: The parent builder.
    ///   - condition: The condition for this step.
    init(builder: ConditionalStyleBuilder, condition: Bool) {
        self.builder = builder
        self.condition = condition
    }
    
    /// Applies a color if the condition is true.
    /// - Parameter color: The named color to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func color(_ color: NamedColor) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingColor(color) }
        return builder
    }
    
    /// Applies a color type if the condition is true.
    /// - Parameter color: The color type to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func color(_ color: ColorType) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingColor(color) }
        return builder
    }
    
    /// Applies a background color if the condition is true.
    /// - Parameter color: The named background color to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func backgroundColor(_ color: NamedBackgroundColor) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingBackgroundColor(.named(color)) }
        return builder
    }
    
    /// Applies a background color type if the condition is true.
    /// - Parameter color: The background color type to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func backgroundColor(_ color: BackgroundColorType) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingBackgroundColor(color) }
        return builder
    }
    
    /// Applies a style if the condition is true.
    /// - Parameter style: The style to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func style(_ style: Style) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingStyle(style) }
        return builder
    }
    
    /// Applies multiple styles if the condition is true.
    /// - Parameter styles: The styles to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func styles(_ styles: Style...) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingStyles(styles) }
        return builder
    }
    
    /// Applies multiple styles from an array if the condition is true.
    /// - Parameter styles: The array of styles to apply.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func styles(_ styles: [Style]) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition) { $0.applyingStyles(styles) }
        return builder
    }
    
    /// Applies a custom transformation if the condition is true.
    /// - Parameter transform: A closure that transforms the string.
    /// - Returns: The parent builder for method chaining.
    @discardableResult
    public func transform(_ transform: @escaping (String) -> String) -> ConditionalStyleBuilder {
        builder.addStep(condition: condition, transform: transform)
        return builder
    }
    
    // Convenience methods for common colors
    public var black: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.black) }
        return self
    }
    public var red: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.red) }
        return self
    }
    public var green: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.green) }
        return self
    }
    public var yellow: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.yellow) }
        return self
    }
    public var blue: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.blue) }
        return self
    }
    public var magenta: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.magenta) }
        return self
    }
    public var cyan: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.cyan) }
        return self
    }
    public var white: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingColor(.white) }
        return self
    }
    
    // Convenience methods for common styles
    public var bold: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.bold) }
        return self
    }
    public var dim: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.dim) }
        return self
    }
    public var italic: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.italic) }
        return self
    }
    public var underline: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.underline) }
        return self
    }
    public var blink: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.blink) }
        return self
    }
    public var swap: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.swap) }
        return self
    }
    public var strikethrough: ConditionalStyleStep { 
        builder.addStep(condition: condition) { $0.applyingStyle(.strikethrough) }
        return self
    }
    
    // Methods to transition back to builder for new conditions
    public func when(_ condition: Bool) -> ConditionalStyleStep {
        return builder.when(condition)
    }
    
    public func when(_ predicate: () -> Bool) -> ConditionalStyleStep {
        return builder.when(predicate)
    }
    
    public func build() -> String {
        return builder.build()
    }
}
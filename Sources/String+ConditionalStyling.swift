//
//  String+ConditionalStyling.swift
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

// MARK: - Conditional Color Application
public extension String {
    
    /// Applies a named color to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the color.
    ///   - color: The named color to apply if the condition is true.
    /// - Returns: The colorized string if condition is true, otherwise the original string.
    func colorIf(_ condition: Bool, _ color: NamedColor) -> String {
        return condition ? applyingColor(color) : self
    }
    
    /// Applies a color type to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the color.
    ///   - color: The color type to apply if the condition is true.
    /// - Returns: The colorized string if condition is true, otherwise the original string.
    func colorIf(_ condition: Bool, _ color: ColorType) -> String {
        return condition ? applyingColor(color) : self
    }
    
    /// Applies a named color based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the color should be applied.
    ///   - color: The named color to apply if the predicate returns true.
    /// - Returns: The colorized string if predicate returns true, otherwise the original string.
    func colorWhen(_ predicate: () -> Bool, _ color: NamedColor) -> String {
        return colorIf(predicate(), color)
    }
    
    /// Applies a color type based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the color should be applied.
    ///   - color: The color type to apply if the predicate returns true.
    /// - Returns: The colorized string if predicate returns true, otherwise the original string.
    func colorWhen(_ predicate: () -> Bool, _ color: ColorType) -> String {
        return colorIf(predicate(), color)
    }
}

// MARK: - Conditional Background Color Application
public extension String {
    
    /// Applies a named background color to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the background color.
    ///   - color: The named background color to apply if the condition is true.
    /// - Returns: The background colorized string if condition is true, otherwise the original string.
    func backgroundColorIf(_ condition: Bool, _ color: NamedBackgroundColor) -> String {
        return condition ? applyingBackgroundColor(.named(color)) : self
    }
    
    /// Applies a background color type to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the background color.
    ///   - color: The background color type to apply if the condition is true.
    /// - Returns: The background colorized string if condition is true, otherwise the original string.
    func backgroundColorIf(_ condition: Bool, _ color: BackgroundColorType) -> String {
        return condition ? applyingBackgroundColor(color) : self
    }
    
    /// Applies a named background color based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the background color should be applied.
    ///   - color: The named background color to apply if the predicate returns true.
    /// - Returns: The background colorized string if predicate returns true, otherwise the original string.
    func backgroundColorWhen(_ predicate: () -> Bool, _ color: NamedBackgroundColor) -> String {
        return backgroundColorIf(predicate(), color)
    }
    
    /// Applies a background color type based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the background color should be applied.
    ///   - color: The background color type to apply if the predicate returns true.
    /// - Returns: The background colorized string if predicate returns true, otherwise the original string.
    func backgroundColorWhen(_ predicate: () -> Bool, _ color: BackgroundColorType) -> String {
        return backgroundColorIf(predicate(), color)
    }
}

// MARK: - Conditional Style Application
public extension String {
    
    /// Applies a style to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the style.
    ///   - style: The style to apply if the condition is true.
    /// - Returns: The styled string if condition is true, otherwise the original string.
    func styleIf(_ condition: Bool, _ style: Style) -> String {
        return condition ? applyingStyle(style) : self
    }
    
    /// Applies multiple styles to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the styles.
    ///   - styles: The array of styles to apply if the condition is true.
    /// - Returns: The styled string if condition is true, otherwise the original string.
    func stylesIf(_ condition: Bool, _ styles: [Style]) -> String {
        return condition ? applyingStyles(styles) : self
    }
    
    /// Applies a style based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the style should be applied.
    ///   - style: The style to apply if the predicate returns true.
    /// - Returns: The styled string if predicate returns true, otherwise the original string.
    func styleWhen(_ predicate: () -> Bool, _ style: Style) -> String {
        return styleIf(predicate(), style)
    }
    
    /// Applies multiple styles based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the styles should be applied.
    ///   - styles: The array of styles to apply if the predicate returns true.
    /// - Returns: The styled string if predicate returns true, otherwise the original string.
    func stylesWhen(_ predicate: () -> Bool, _ styles: [Style]) -> String {
        return stylesIf(predicate(), styles)
    }
}

// MARK: - General Conditional Application
public extension String {
    
    /// Applies a custom transformation to the string conditionally.
    /// - Parameters:
    ///   - condition: The condition that determines whether to apply the transformation.
    ///   - transform: A closure that transforms the string if the condition is true.
    /// - Returns: The transformed string if condition is true, otherwise the original string.
    func applyIf(_ condition: Bool, transform: (String) -> String) -> String {
        return condition ? transform(self) : self
    }
    
    /// Applies a custom transformation based on a closure predicate.
    /// - Parameters:
    ///   - predicate: A closure that returns true if the transformation should be applied.
    ///   - transform: A closure that transforms the string if the predicate returns true.
    /// - Returns: The transformed string if predicate returns true, otherwise the original string.
    func applyWhen(_ predicate: () -> Bool, transform: (String) -> String) -> String {
        return applyIf(predicate(), transform: transform)
    }
    
    /// Creates a conditional style builder for more complex conditional styling scenarios.
    /// - Returns: A `ConditionalStyleBuilder` instance for building conditional styles.
    var conditionalStyled: ConditionalStyleBuilder {
        return ConditionalStyleBuilder(text: self)
    }
}

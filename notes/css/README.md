## Selector

* element.class: select element that has specific class
* element1 element2: select child of the element1
* element1+element2: select sibling element
* element:state: select element by status
* body h1+p .special: select element `<p>` that contains `special` class,
which come just after `<h1>`, and is the child of `<body>`
* element, element, element: select those element

## Cascade and inheritance

* Later styles replace conflicting styles that appear earlier in the stylesheet. This is the cascade rule.
* More specific selector will cancel other. Like class is more specific that element
* @media can apply rule by browser view point
* When browser met some css it doesn't understand, it just ignore it.

* Some CSS property values set on parent elements are inherited by their child
* `inherit`, `initial`, `revert`, `revert-layer`, `unset` can control the inheritance
* use `all: <val>` to set all the property at once

* Overwrite won't replace all the rule, it just overwrite the property.
* Common practice is to define some global style and overwrite some property by more specific selector
* Specific order: Identifier > Class > Element
* There is also an extra `!important` value to indicate a property's specificity value.
But don't use it when you can avoid it.
* Normal style take higher priority than `@layer`

## CSS selectors

* `h1, .special`                 => Combine two selector and apply same style sheet by adding comma between them
* `h1`                           => present an element selector
* `.class`                       => present a class selector
* `#id`                          => present a identifier selector
* `a[title]`                     => element with attribute `<a title/>`
* `a[href="https://github.com"]` => element `a` with the `href` attribute and a specific value `"https://github.com"`
* `a:hover`                      => pseudo-class, present a certain states of an element
* `p::first-line`                => pseudo-element, selects the first line of text inside an element
* `article > p`                  => select the direct children p of element article
* `*`                            => universal selector
* `.class1.class2`               => chain multiple class
* `p[class~="special"]`          => element has class attribute whose value match "special" or contains "special" in space separated list
* `p[class^="special"]`          => element has class attribute whose value begin with "special"
* `p[class$="special"]`          => element has class attribute whose value end with "special"
* `p[class*="special"]`          => element has class attribute whose value contains anywhere with "special"

### pseudo-class

A pseudo-class is a selector that selects elements that are in specific state.
It act like it apply a class to some special element.

### pseudo-element

It act like it add a new HTML element into dom.

Avoid inserting text into `::before`, `::after` element, it will increase complexity.

To draw image we can insert empty text by `content: ""` and use `display: block`.

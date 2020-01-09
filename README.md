[![Actions Status](https://github.com/mirego/html-test-helpers/workflows/CI/badge.svg?branch=master)](https://github.com/mirego/html-test-helpers/actions)

# HtmlTestHelpers

Functions helpers for unit testing.
Validate HTML tag identified by data-testid attributes

## Usage

Assuming that you have the following HTML:

```html
<!DOCTYPE html>
<html>
  <body>
    <section id="content">
      <p data-testid="paragraph-id">First paragraph content</p>
      <ul>
        <li data-testid="test-li-id-1" class="li-class-1">First line</li>
        <li data-testid="test-li-id-2" class="li-class-2">Second line</li>
      </ul>
      <a data-testid="test-link-id" class="my-link-class my-other-class" href="/expected/link">Details</a>
      <span data-testid="test-footer-id" class="footer small">2020</span>
    </section>
  </body>
</html>
```

You can validate your expected response as follow :

```elixir
raw_html
|> assert_html_text("paragraph-id", "First paragraph content")
|> assert_html_attribute("test-link-id", "href", "/expected/link")
|> assert_html_attribute("test-link-id", "class", :contains, "my-link-class")
|> assert_html_attribute("test-footer-testid", "class", :equals, "footer small")
# =>
# [{"html", [],
#   [
#     {"body", [],
#     [
#       {"section", [{"id", "content"}],
#         [
#           {"p", [{"data-testid", "paragraph-id"}],
#           ["First paragraph content"]},
#           {"ul", [],
#           [
#             {"li",
#               [{"data-testid", "test-li-id-1"}, {"class", "li-class-1"}],
#               [" First line "]},
#             {"li",
#               [{"data-testid", "test-li-id-2"}, {"class", "li-class-2"}],
#               [" Second line "]}
#           ]},
#           {"a",
#           [
#             {"data-testid", "test-link-id"},
#             {"class", "my-link-class my-other-class"},
#             {"href", "/expected/link"}
#           ], ["Details"]},
#           {"span",
#           [{"data-testid", "test-footer-id"}, {"class", "footer small"}],
#           ["2020"]}
#         ]}
#     ]}
#   ]}
# ]}
```

if there is an error :

```elixir
assert_html_text(raw_html, "paragraph-id", "First paragraph content")
# =>
# ** (ExUnit.AssertionError)

# Value identified by data-testid[paragraph-id] is not as expected.

# left:  "First paragraph content"
# right: "wrong content"

#     (html_test_helpers) lib/html_test_helpers.ex:106: HtmlTestHelpers.assert_html_text/3
```

Also if you just need the value identified by `data-testid` attribute you can use :

```elixir
html_texts(raw_html, "test-li-id")
# =>
# ["First line", "Second line]

html_attributes(raw_html, "test-li-id", "class")
# =>
# ["li-class-1", "li-class-2"]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `html_test_helpers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:html_test_helpers, "~> 0.1.0, only: :test}
  ]
end
```

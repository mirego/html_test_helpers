<p align="center">
  <img src="https://user-images.githubusercontent.com/11348/73123814-10d59880-3f62-11ea-9fac-4de5a4debd2f.png" width="600" />
  <br /><br />
  <code>HTMLTestHelpers</code> provides function helpers for unit testing allowing easy assertions for<br /> HTML elements data queried by <code>data-testid</code> attribute.
  <br /><br />
  <a href="https://github.com/mirego/html_test_helpers/actions"><img src="https://github.com/mirego/html_test_helper/workflows/CI/badge.svg?branch=master" /></a>
</p>

## Installation

The package can be installed by adding `html_test_helpers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:html_test_helpers, github: "mirego/html_test_helpers", tag: "v0.1.1", only: :test}
  ]
end
```

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
      <a
        data-testid="test-link-id"
        class="my-link-class my-other-class"
        href="/expected/link"
        >Details</a
      >
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

#     (html_test_helpers) lib/html_test_helpers.ex:106: HTMLTestHelpers.assert_html_text/3
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

## Contributors

- @romarickb

## License

`html_test_helpers` is © 2019 [Mirego](https://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause). See the [`LICENSE.md`](https://github.com/mirego/html_test_helpers/blob/master/LICENSE.md) file.

## About Mirego

[Mirego](https://www.mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We’re a team of [talented people](https://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://www.mirego.org).

We also [love open-source software](https://open.mirego.com) and we try to give back to the community as much as we can.

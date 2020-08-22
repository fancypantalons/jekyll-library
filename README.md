# Jekyll::Library

Jekyll::Library is a Jekyll generator plugin that automates the retrieval of book covers and related metadata based on an ISBN.  During operation the plugin:

1. Identifies pages that include ISBN numbers in their front matter.  Pages are chosen based on the `pages` and `collections` configuration settings.
2. Uses the Calibre `calibredb` tool to retrieve metadata and a cover from your calibre database
  1. Stores the cover image in the location specified by the `cover_folder` setting.
4. Updates the page front matter to add
  1. image - contains the relative URL for the cover
  2. book - contains a hash containing other relevant metadata (see below)

The additional information in the front matter can then be used during page layout to include the book metadata in the page.

## Pre-requisites

This plugin makes use of the `calibredb` tool that ships with [Calibre](https://calibre-ebook.com/).  This tool must be available and in the path of the shell that is executing the Jekyll build.  Naturally, your Calibre database must also have records for the books you're referencing in your posts.

## Installation

Add this plugin to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem "jekyll-library", git: "git@github.com:fancypantalons/jekyll-library.git"
end
```

And then execute:

    $ bundle

## Configuration

Without any additional configuration this plugin will **not** process any pages.

The following is an example of a basic configuration:

```yaml
library:
  cover_folder: assets/images/covers
  collections:
    - posts
```

### Page selection

The following settings control the pages the plugin selects for processing:

- `pages` - A boolean setting that, if set to `true`, causes the plugin to generate short URLs for Jekyll pages.
- `collections` - A list of collection names.  The plugin will generate short URLs for the pages in these collections.

### Cover storage

Cover files retrieved by `calibredb` are stored in the path specified by the `cover_folder` setting.  This setting is required!

# Thanks

* Huge thanks to the entire Calibre team!

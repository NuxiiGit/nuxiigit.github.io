My homepage and portfolio site. Currently I host [social media links](/content/contact.html), [project information](/content/projects.html) and [a blog](/content/blog/posts.html). The site uses plain HTML and CSS with very little JavaScript; a custom site generator was written using Ruby to maintain consistency between pages. This also helped reduce the burden of creating content by parsing information from other file formats, such as YAML or Markdown. A mature web development framework, such as Rails, Django or React, was not used since it would be inappropriate for a simple static site.

The website also offers the ability to change the theme by clicking the lightbulb symbol on the sidebar, with Figures 1 and 2 showing this effect.

<div class="centre">
	<%= figure("/image/figures/website-dark.png", desc: "Dark theme", ref: 1, width: 320) %>
	<%= figure("/image/figures/website-light.png", desc: "Light theme", ref: 2, width: 320) %>
</div>

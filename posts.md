---
layout: post ## this refers to home.html in _layouts dir
---

<!-- {% for post in site.posts %}
{% if post.ext == ".markdown" %}
- [{{post.title}}]({{post.url}}) ({{post.date | date: "%d %B %Y"}}) - *{{post.categories | array_to_sentence_string}}*
{% endif %}
{% endfor %} -->

{% for post in site.posts %}
{% if post.ext == ".markdown" %}
<article>
  <h2>
    <a href="{{ post.url }}">
      {{ post.title }}
    </a>
  </h2>
  <time datetime="{{ post.date | date: "%Y-%m-%d" }}">{{ post.date | date_to_long_string }}</time><br/><br/>
  {{ post.content | strip_html | truncatewords: 100 }}
</article>
{% endif %}
{% endfor %}

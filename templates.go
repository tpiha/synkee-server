package main

import (
	"html/template"
	"log"
	"net/http"
)

var templates map[string]*template.Template

// Initializes template system
func TemplatesInit() {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}
	templates["home"] = template.Must(template.ParseFiles("templates/base.html", "templates/home.html"))
}

// Renders template with some page data variables
func RenderTemplate(w http.ResponseWriter, name string, data *PageData) error {
	tmpl, ok := templates[name]
	if !ok {
		log.Fatalln("Failed loading template")
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	tmpl.ExecuteTemplate(w, "base", data)

	return nil
}

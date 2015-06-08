package main

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

// View for handling Synkee dashboard
func ViewDashboard(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	p := NewPageData(r)
	RenderTemplate(w, "home", p)
}

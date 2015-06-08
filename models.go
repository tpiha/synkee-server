package main

import (
	"net/http"
)

// Page data model, used for passing variables to the template
type PageData struct {
	AppUrl string
}

func NewPageData(r *http.Request) *PageData {
	p := new(PageData)
	p.AppUrl = "/app"
	return p
}

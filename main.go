package main

import (
	"github.com/julienschmidt/httprouter"
	"log"
	"net/http"
	"path/filepath"
	"runtime/debug"
)

var routes map[string]func(http.ResponseWriter, *http.Request)

func main() {
	TemplatesInit()

	router := httprouter.New()

	// Setting GET routes
	router.GET("/app", ViewDashboard)

	defer func() {
		if err := recover(); err != nil {
			log.Printf("[main] Error: %s Trace: %s", err, debug.Stack())
		}
	}()

	router.ServeFiles("/app/static/*filepath", http.Dir(filepath.Join(HomeDir(), "static")))
	http.ListenAndServe(":8080", router)
}

const demoForm = document.getElementById("demo_form");
const demo = document.getElementById("demo_results");
const demoGraph = document.getElementById("demo_graph");
const demoResults = document.getElementById("demo_value");

demo.style.display = "none"

demoForm.addEventListener("submit", (e) => {
      e.preventDefault()
      const formData = new FormData(e.currentTarget);
      const dataPayload = JSON.stringify({
	'data': formData.get('data').match(/\d+/g).map(val => Number(val)),
	'is_sample': formData.get('is_sample') == 'on' ? true : false
      });

	demo.style.display = "block"
	// get json results
      const headersForResult = {
	      "Content-Type": "application/json",
	      "Accept": "application/json"
      }
      fetch(`${window.location.origin}/api/summary`,
	{
		method: "POST",
		headers: headersForResult,
		body: dataPayload	
	}
      ).then(response => {
	      if (response.ok) {
		      return response.json()
	      } else {
		      throw "Error in getting response"
	      }
      })
	.then(data => {
	      demo.style.display = "block"
	      demoResults.innerHTML = ''
	      for (const [key, value] of Object.entries(data)) {
		let newLi = document.createElement("li")
		newLi.appendChild(document.createTextNode(key + " : " + value))
		demoResults.appendChild(newLi)
	      }
	})
	.catch(e => {
		let newLi = document.createElement("li")
		newLi.appendChild(document.createTextNode("Ouch. Something happens"))
		demoResults.appendChild(newLi)
	})

	// get image
      const headersForGraph = {
	      "Content-Type": "application/json",
	      "Accept": "image/jpg"
      }
      fetch(`${window.location.origin}/api/summary`,
	{
		method: "POST",
		headers: headersForGraph,
		body: dataPayload
	}
      ).then(response => {
		if (response.ok) {
			return response.blob()
		} else {
			throw "Error in getting response"
		}
      }).then(data => {
		const url = URL.createObjectURL(data)
		demoGraph.src = url
	})
	.catch(e => {
		demoGraph.src = '/warning.svg'
	})
})

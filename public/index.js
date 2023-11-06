const demoForm = document.getElementById("demo_form");
const demo = document.getElementById("demo");
const demoGraph = document.getElementById("demo_graph");
const demoResults = document.getElementById("demo_results");

demo.style.display = "none"

async function getStatData(data, headers) {
      const response = await fetch(
	`${window.location.origin}/api/summary`,
	{
		method: "POST",
		headers: headers,
		body: data
	}
      )
      if (headers['Accept'] == 'application/json') {
	      return await response.json()
      } else if (headers['Accept'] == 'image/jpg') {
	      return await response.blob()
      }
}

demoForm.addEventListener("submit", (e) => {
      e.preventDefault()
      const formData = new FormData(e.currentTarget);
      const headersForResult = {
	      "Content-Type": "application/json",
	      "Accept": "application/json"
      }
      const headersForGraph = {
	      "Content-Type": "application/json",
	      "Accept": "image/jpg"
      }
      const dataPayload = JSON.stringify({
	'data': formData.get('data').split(',').map(val => Number(val)),
	'is_sample': formData.get('is_sample') == 'on' ? true : false
      });
      getStatData(dataPayload, headersForResult).then(data => {
	      demo.style.display = "block"
	      demoResults.innerHTML = ''
	      for (const [key, value] of Object.entries(data)) {
		let newLi = document.createElement("li")
		newLi.appendChild(document.createTextNode(key + " : " + value))
		demoResults.appendChild(newLi)
	      }
      })
      getStatData(dataPayload, headersForGraph).then(data => {
	      const url = URL.createObjectURL(data)
	      demoGraph.src = url
      })
})

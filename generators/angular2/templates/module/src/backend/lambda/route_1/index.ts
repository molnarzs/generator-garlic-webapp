export const Handler = (request) => {
  console.log("Request arrived", JSON.stringify(request.body, null, 2))
  return "Hello!"
}

#pragma strict
 
var cubemap : Cubemap;
var currentMaterial : Material;
var updateRate = 1.0;
private var renderFromPosition : Transform;
private var minz = -1.0;
 
function Start () {
    renderFromPosition = transform;
}
 
function Update () {
    if(Time.time - updateRate > minz){
        minz = Time.time - Time.deltaTime;
        RenderMe();
        currentMaterial.SetTexture("_Cube",cubemap);
        GetComponent.<Renderer>().material = currentMaterial;
    }
}
 
function RenderMe(){
    var go = new GameObject( "CubemapCamera"+Random.seed, Camera );
       
    go.GetComponent.<Camera>().backgroundColor = Color.black;
    go.GetComponent.<Camera>().cullingMask = ~(1<<8);
    go.transform.position = renderFromPosition.position;
    if(renderFromPosition.GetComponent.<Renderer>() )go.transform.position = renderFromPosition.GetComponent.<Renderer>().bounds.center;
    go.transform.rotation = Quaternion.identity;
   
    go.GetComponent.<Camera>().RenderToCubemap( cubemap );
 
    DestroyImmediate( go );
}
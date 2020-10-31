using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridMaster : MonoBehaviour
{
    public GameObject nodeObj;                              //node prefab
    public float unitSize;                                  //distance between nodes
    public int minConnection;                               //min num of connections to pass as good node

    public int height;                                      //number of node per column
    public int width;                                       //number of nodes per row

    public List<GameObject> nodeList;                       //main node list
    public List<GameObject> badNodeList;                    //list of all bad nodes
    public List<GameObject> refreshNodeList;                //list of all refresh nodes


    // Use this for initialization
    void Awake()
    {
        //Instatiates all nodes according to height/width with unitSize as the distance between them
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x <  width; ++x)
            {
                GameObject node = Instantiate(nodeObj, new Vector3((int)transform.position.x + (x * unitSize), (int)transform.position.y - (y*unitSize), 10), Quaternion.identity);

                //just passing down some information
                node.name = x + " , " + y;
                node.GetComponent<PathNode>().SetNodeDist(unitSize);
                node.GetComponent<PathNode>().SetMinConnection(minConnection);
                node.GetComponent<PathNode>().SetGridMaster(GetComponent<GridMaster>());

                //adds to overall nodelist
                nodeList.Add(node);
            }
        }

        //coroutine to mimic a latestart
        StartCoroutine(LateStart());
    }

    //goes through all nodes in main nodelist and connects them
    public void CheckAllNodes()
    {

        for(int listCount = nodeList.Count - 1; listCount >= 0; --listCount)
        {
            if (!nodeList[listCount].GetComponent<PathNode>().badNode || !nodeList[listCount].GetComponent<PathNode>().refreshNode)
            {
                nodeList[listCount].GetComponent<PathNode>().SetColor(Color.yellow);
                nodeList[listCount].GetComponent<PathNode>().ConnectNode();
            }
        }
    }

    //checks all nodes in main nodelist to remove badNodes
    public void CheckAllBadNodes()
    {
        for(int listCount = nodeList.Count - 1; listCount >= 0; --listCount)
        {
            if (!nodeList[listCount].GetComponent<PathNode>().badNode || !nodeList[listCount].GetComponent<PathNode>().refreshNode)
            {
                nodeList[listCount].GetComponent<PathNode>().CheckBadNode();
            }
        }
    }

    //checks refreshnodes and converts back to normal node 
    public void CheckRefreshNodes()
    {
        for (int listCount = refreshNodeList.Count - 1; listCount >= 0; --listCount)
        {
            refreshNodeList[listCount].GetComponent<PathNode>().CheckRefreshCol();
        }
                
    }
	
    //late start to remove badnodes
    IEnumerator LateStart()
    {
        yield return new WaitForFixedUpdate();
        {
            CheckAllNodes();
            CheckAllBadNodes();
        }
    }
	// Update is called once per frame
	void Update ()
    {
		if(Input.GetKeyDown(KeyCode.Q))
        {
            CheckRefreshNodes();
        }
	}
}

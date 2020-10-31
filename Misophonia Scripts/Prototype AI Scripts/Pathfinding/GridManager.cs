using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridManager : MonoBehaviour
{
    public GameObject node1 = null;
    public GameObject node2 = null;

    List<GameObject> gridMasterList = new List<GameObject>();
    List<GameObject> nodeMasterList = new List<GameObject>();
    List<GameObject> refreshMasterList = new List<GameObject>();

	// Use this for initialization
	void Start ()
    {
        gridMasterList.AddRange(GameObject.FindGameObjectsWithTag("GM"));
        StartCoroutine(LastStart());
        
	}
	
	// Update is called once per frame
	void Update ()
    {
		//if(Input.GetKeyDown(KeyCode.I))
  //      {
  //          path = PathController.FindPath(node1, node2);

  //          if(path.Count > 0)
  //          {
  //              foreach(GameObject n in path)
  //              {
  //                  n.GetComponent<PathNode>().SetColor(Color.green);
  //              }
  //          }
  //      }
	}

    public GameObject GetClosestNode(Vector2 position)
    {
        GameObject bestTarget = null;

        float closestDistSqr = Mathf.Infinity;

        foreach(GameObject n in nodeMasterList)
        {
            Vector2 dirToTarget = (Vector2)n.transform.position - position;
            float dSqrToTarget = dirToTarget.sqrMagnitude;

            if(dSqrToTarget < closestDistSqr)
            {
                closestDistSqr = dSqrToTarget;
                bestTarget = n;
            }
        }

        return bestTarget;
    }

    void CompileMasterGrid()
    {
        foreach(GameObject gm in gridMasterList)
        {
            nodeMasterList.AddRange(gm.GetComponent<GridMaster>().nodeList.ToArray());
        }

        foreach (GameObject gm in refreshMasterList)
        {
            refreshMasterList.AddRange(gm.GetComponent<GridMaster>().refreshNodeList.ToArray());
        }

        foreach (GameObject gm in refreshMasterList)
        {
            refreshMasterList.AddRange(gm.GetComponent<GridMaster>().refreshNodeList.ToArray());
        }
    }

    void ReconnectNodes()
    {
        for (int listCount = nodeMasterList.Count - 1; listCount >= 0; --listCount)
        {
            if (!nodeMasterList[listCount].GetComponent<PathNode>().badNode || !nodeMasterList[listCount].GetComponent<PathNode>().refreshNode)
            {
                nodeMasterList[listCount].GetComponent<PathNode>().SetColor(Color.yellow);
                nodeMasterList[listCount].GetComponent<PathNode>().ConnectNode();
                nodeMasterList[listCount].GetComponent<PathNode>().CheckBadNode();
            }
        }
    }

    IEnumerator LastStart()
    {
        yield return new WaitForFixedUpdate();
        CompileMasterGrid();
    }
}

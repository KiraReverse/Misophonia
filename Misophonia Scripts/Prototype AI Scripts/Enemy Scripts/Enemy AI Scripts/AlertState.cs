using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AlertState : BaseBehavior
{
    //Global Stats
    public StateController stateCon;
    public EnemySoundController enemySfx;

    GridManager gridManager;

    int dumbCounter;
    const int dumbCheck = 300;
    int stuckCounter;
    const int stuckCheck = 5;
    const int abandonAlert = 2000;

    int nodeNum = 0;

    bool reached;

    List<GameObject> path;

    public float moveSpeed;
    public float turnSpeed;
    public float aggroThreshold;
    public float distTolerance;
    public float rotSpeed;

    //Alert Stats
    Vector2 aggroPos;

    public float aggroValue;

    // Use this for initialization
    void Awake ()
    {
        gridManager = GameObject.FindGameObjectWithTag("GridManager").GetComponent<GridManager>();

        path = new List<GameObject>();

        reached = false;

        aggroValue = aggroThreshold = 1;

        dumbCounter = 0;
        stuckCounter = 0;
    }

    public override void Enter()
    {
        ResetStats();
        AlertPath();

        if (path.Count <= 0 || path == null)
        {

            stateCon.CurrState = StateController.State.alertExit;
        }

        else
        {
            stateCon.CurrState = StateController.State.alert;
        }
    }

    public override void Exit()
    {
        aggroValue = aggroThreshold;

        //stateCon.CurrState = StateController.State.searchEnter;
        stateCon.CurrState = StateController.State.ponderEnter;
    }

    public override void StateLoop()
    {


        StuckCheck();

        //if (dumbCounter >= dumbCheck || path.Count == 0)
        //{
        //    AlertPath();
        //}


        if (reached)
        {
            stateCon.CurrState = StateController.State.alertExit;
            return;
        }

        if (path.Count > 0 && !reached)
        {
            //Vector3 target = new Vector3(gridManager.GridToWorld(path[nodeNum]).x, gridManager.GridToWorld(path[nodeNum]).y, 0) - transform.position;
            Vector3 target = path[nodeNum].transform.position - transform.position;
            var newDir = Quaternion.LookRotation(target, Vector3.forward);
            newDir.x = 0;
            newDir.y = 0;
            transform.rotation = Quaternion.Slerp(transform.rotation, newDir, Time.deltaTime * rotSpeed);
            ++dumbCounter;

            //transform.position = Vector2.MoveTowards(transform.position, gridManager.GridToWorld(path[nodeNum]), moveSpeed * Time.deltaTime);
            transform.position = Vector2.MoveTowards(transform.position, path[nodeNum].transform.position, moveSpeed * Time.deltaTime);
            Vector2 currPos = transform.position;

            enemySfx.PlayAlert();

            //float distA = Vector2.Distance(currPos, gridManager.GridToWorld(path[path.Count - 1]));
            float distA = Vector2.Distance(currPos, path[path.Count - 1].transform.position);

            if (distA <= distTolerance)
            {
                reached = true;
                dumbCounter = 0;
            }

            else if (path.Count > 0)
            {
                //float distB = Vector2.Distance(currPos, gridManager.GridToWorld(path[nodeNum]));
                float distB = Vector2.Distance(currPos, path[nodeNum].transform.position);

                if (distB <= distTolerance && nodeNum < path.Count - 1)
                {
                    ++nodeNum;
                    dumbCounter = 0;
                }
            }
        }
    }

    public override void ResetStats()
    {
        reached = false;

        if (path != null)
        {
            path.Clear();
        }

        nodeNum = 0;
        dumbCounter = 0;
        stuckCounter = 0;

        aggroValue = aggroThreshold;
    }

    public void AlertInterrupt(float noiseV, Vector2 alertPos)
    {
        stateCon.nextState = StateController.State.alertEnter;

        if (stateCon.nextState != stateCon.GetCurrEnterState() && stateCon.CurrState != StateController.State.chase)
       // {
            if (noiseV >= aggroThreshold)
            {
                if (noiseV > aggroValue)
                {
                    
                    stateCon.interrupt = true;
                    aggroPos = alertPos;
                    aggroValue = noiseV;
                }
            }
       // }

        else
        {
            stateCon.nextState = StateController.State.wait;
        }
    }

    bool AlertPath()
    {




        path = PathController.FindPath(gridManager.GetClosestNode(gameObject.transform.position), gridManager.GetClosestNode(aggroPos));
        ++stuckCounter;

        dumbCounter = 0;
        nodeNum = 0;

        if (path.Count <= 0 || path == null )
        {
            return false;
        }

        return true;
    }

    void StuckCheck()
    {

        //if(stuckCounter >= abandonAlert)
        //{
        //    reached = true;
        //}

        //else if (stuckCounter >= stuckCheck)
        //{

        //    Vector3 stuckPos = transform.position;

        //    Point p = gridManager.WorldToGrid(transform.position);

        //    if (p != null)
        //    {
        //        transform.position = Vector3.MoveTowards(transform.position, gridManager.GridToWorld(p), moveSpeed * Time.deltaTime);
        //    }

        //    else

        //    {
        //        transform.position += new Vector3(Random.Range(-0.02f, 0.02f), Random.Range(-0.02f, 0.02f), transform.position.z);
        //    }

        //    if (transform.position != stuckPos)
        //    {
        //        stuckCounter = 0;
        //    }

        //}

          if (stuckCounter >= stuckCheck)
        {

            Vector3 stuckPos = transform.position;

            //Point p = gridManager.WorldToGrid(transform.position);
            Vector3 unstuckPos = transform.position + new Vector3(0.1f, 0.1f, 0);

            //transform.position = Vector3.MoveTowards(transform.position, gridManager.GridToWorld(p), Time.deltaTime);
            transform.position = Vector3.MoveTowards(transform.position, unstuckPos, Time.deltaTime);

            if (transform.position != stuckPos)
            {
                stuckCounter = 0;
            }

        }
    }

    // Update is called once per frame
    void Update () {
		
	}
}

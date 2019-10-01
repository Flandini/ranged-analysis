#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  MPI_Init(0, 0);

  int WorldRank;
  MPI_Comm_rank(MPI_COMM_WORLD, &WorldRank);

  int WorldSize;
  MPI_Comm_size(MPI_COMM_WORLD, &WorldSize);

  if (WorldSize != 6) {
    std::cout << "Needs WorldSize of 6" << std::endl;
    return -1;
  }


  int number;

  if (WorldRank == 0) {
    int self = 0;
    number = 0;
    MPI_Send(&number, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    return 0;
  } else if (WorldRank != 0) {
    int recvFrom = WorldRank - 1;

    int sendTo = WorldRank + 1;


    MPI_Recv(&number, 1, MPI_INT, recvFrom, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

    if (sendTo >= WorldSize) {
      std::cout << "Rank 5 got: " << number << std::endl;
    } else {
      number++;
      MPI_Send(&number, 1, MPI_INT, sendTo, 0, MPI_COMM_WORLD);
    }
  }

  MPI_Finalize();

  //if (WorldRank == 0) {
    //number = -1;
    //MPI_Send(&number,
             //1,
             //MPI_INT,
             //1,
             //0,
             //MPI_COMM_WORLD);
  //} else if (WorldRank == 1) {
    //MPI_Recv(
              //&number,
              //1,
              //MPI_INT,
              //0,
              //0,
              //MPI_COMM_WORLD,
              //MPI_STATUS_IGNORE
            //);
    //std::cout << "Received: " << number << " from 1" << std::endl;
  //}

  return 0;
}
